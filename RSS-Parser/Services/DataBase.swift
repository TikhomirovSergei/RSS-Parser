//
//  DataBase.swift
//  RSS-Parser
//
//  Created by Сергей on 13/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataBase: DataBaseProtocol {
    private static var selectedUrl = ""
    private static var menuIsOpen = false
    private static var selectedNews: NewsModelProtocol? = nil
    let lock = NSLock()
    
    func setSelectedNews(news: NewsModelProtocol) {
        DataBase.selectedNews = news
    }
    
    func getSelectedNews() -> NewsModelProtocol? {
        return DataBase.selectedNews
    }
    
    func setSelectedUrl(selectedUrl: String) {
        DataBase.selectedUrl = selectedUrl
    }
    
    func getSelectedUrl() -> String {
        return DataBase.selectedUrl
    }
    
    func setMenuIsOpen(menuIsOpen: Bool) {
        DataBase.menuIsOpen = menuIsOpen
    }
    
    func getMenuIsOpen() -> Bool {
        return DataBase.menuIsOpen
    }
    
    func saveNewsFeed(newsFeed: NewsFeedModelProtocol) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw "Get application delegate error."
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try self.clearNewsFeed(context: managedContext, url: newsFeed.url)
            
            let newsFeedEntity = NSEntityDescription.entity(forEntityName: "NewsFeed", in: managedContext)!
            let newsFeedObject = NSManagedObject(entity: newsFeedEntity, insertInto: managedContext)
            
            newsFeedObject.setValue(newsFeed.url, forKeyPath: "url")
            newsFeedObject.setValue(newsFeed.title, forKeyPath: "title")
            newsFeedObject.setValue(newsFeed.link, forKeyPath: "link")
            newsFeedObject.setValue(newsFeed.desc, forKeyPath: "desc")
            
            try managedContext.save()
            
            for i in 0..<newsFeed.news.count {
                let newsEntity = NSEntityDescription.entity(forEntityName: "News", in: managedContext)!
                let newsObject = NSManagedObject(entity: newsEntity, insertInto: managedContext)
                
                newsObject.setValue(newsFeed.news[i].title, forKey: "title")
                newsObject.setValue(newsFeed.news[i].link, forKey: "link")
                newsObject.setValue(newsFeed.news[i].desc, forKey: "desc")
                newsObject.setValue(newsFeed.news[i].pubDate, forKey: "pubDate")
                newsObject.setValue(newsFeed.news[i].author, forKey: "author")
                newsObject.setValue(newsFeed.news[i].thumbnail, forKey: "thumbnail")
                newsObject.setValue(newsFeed.news[i].image?.pngData(), forKey: "image")
                
                newsObject.setValue(newsFeedObject, forKey: "newsFeed")
            }
            
            try managedContext.save()
        }  catch {
            throw error
        }
    }
    
    func deleteNewsFeed(url: String) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw "Get application delegate error."
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            try self.clearNewsFeed(context: managedContext, url: url)
        } catch {
            throw error
        }
    }
    
    func updateNews(news: NewsModelProtocol) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw "Get application delegate error."
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        DispatchQueue.global().async {
            do {
                self.lock.lock()
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
                
                let titlePredicate = NSPredicate(format: "title = %@", news.title)
                let linkPredicate = NSPredicate(format: "link = %@", news.link)
                let descPredicate = NSPredicate(format: "desc = %@", news.desc)
                let pubDatePredicate = NSPredicate(format: "pubDate = %@", news.pubDate)
                let authorPredicate = NSPredicate(format: "author = %@", news.author)
                let thumbnailPredicate = NSPredicate(format: "thumbnail = %@", news.thumbnail)
                
                let subPredicates : [NSPredicate] = [titlePredicate, linkPredicate, descPredicate, pubDatePredicate, authorPredicate, thumbnailPredicate]
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
                
                if let fetchResults = try? managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                    if fetchResults.count != 0 {
                        let item = fetchResults[0]
                        item.setValue(news.image?.pngData(), forKey: "image")
                        
                        try managedContext.save()
                        self.lock.unlock()
                    }
                }
            } catch {
                self.lock.unlock()
            }
        }
    }
    
    func getNewsFeed(url: String) throws -> NewsFeedModelProtocol {
        var newsFeedModel = NewsFeedModel(url: "", title: "", link: "", desc: "", news: [])
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw "Get application delegate error."
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
        
        do {
            let newsArray = try managedContext.fetch(fetchRequest)
            
            for news in newsArray as! [News] {
                guard let newsFeedModelBD = news.newsFeed else {
                    return newsFeedModel
                }
                
                let newsFeed = newsFeedModelBD as NewsFeed
                
                if url == "" || newsFeed.url == url {
                    if newsFeedModel.url == "" {
                        newsFeedModel.url = newsFeed.url!
                        newsFeedModel.title = newsFeed.title!
                        newsFeedModel.link = newsFeed.link!
                        newsFeedModel.desc = newsFeed.desc!
                    }
                    
                    let newsItem = NewsModel(
                        title: news.title!,
                        link: news.link!,
                        desc: news.desc!,
                        pubDate: news.pubDate!,
                        author: news.author!,
                        thumbnail: news.thumbnail!,
                        image: news.image != nil ? UIImage(data: news.image!) : nil
                    )
                    
                    newsFeedModel.news.append(newsItem)
                }
            }
        } catch {
            throw error
        }
        
        return newsFeedModel
    }
    
    func getNewsFeeds() throws -> [NewsFeedModelProtocol] {
        var newsFeeds: [NewsFeedModelProtocol] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw "Get application delegate error."
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NewsFeed")
        
        do {
            let newsFeedArray = try managedContext.fetch(fetchRequest)
            
            for newsFeed in newsFeedArray as! [NewsFeed] {
                let nFeed = NewsFeedModel(url: newsFeed.url!, title: newsFeed.title!, link: newsFeed.link!, desc: newsFeed.desc!, news: [])
                newsFeeds.append(nFeed)
            }
        } catch {
            throw error
        }
        
        return newsFeeds.sorted { $0.title > $1.title }
    }
    
    private func clearNewsFeed(context: NSManagedObjectContext, url: String) throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsFeed")
        request.predicate = NSPredicate(format:"url = %@", url)
        
        let result = try? context.fetch(request)
        let resultData = result as! [NSManagedObject]
        
        for object in resultData {
            context.delete(object)
        }
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }
}
