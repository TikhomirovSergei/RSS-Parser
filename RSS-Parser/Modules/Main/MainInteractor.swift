//
//  MainInteractor.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class MainInteractor: MainInteractorProtocol {
    private let title = "New RSS"
    private let inputPlaceholder = "set url"
    private let openUrl = "Open original"
    private let cancel = "Cancel"
    
    weak var presenter: MainPresenterProtocol!
    var router: MainRouterProtocol!
    let service: ServiceProtocol = Service()
    let dataBase: DataBaseProtocol = DataBase()
    
    var defaultTitle = "RSS Parser"
    private var url: String = ""
    private var refreshTime = Date()
    
    required init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
    
    func getDefaultNewsFeed() {
        do {
            let newsFeeds = try dataBase.getNewsFeeds()
            if newsFeeds.count > 0 {
                url = newsFeeds[0].url
                self.presenter.endLoading()
                self.presenter.hideStartView()
                self.presenter.updateHeaderInfo(title: newsFeeds[0].title, isEmptyList: false)
            } else {
                self.presenter.showStartView()
                self.presenter.updateHeaderInfo(title: defaultTitle, isEmptyList: true)
            }
        } catch {
            self.presenter.showStartView()
            presenter.showError(error: error)
            self.presenter.updateHeaderInfo(title: defaultTitle, isEmptyList: true)
        }
    }
    
    func refreshData() {
        let diff = Int(Date().timeIntervalSince1970 - refreshTime.timeIntervalSince1970)
        if diff >= 60 {
            refreshTime = Date()
            self.service.getNews(urlString: url) { rss, error in
                guard let rss = rss,
                    error == nil else {
                        self.presenter.showError(error: error!)
                        self.presenter.endRefreshing()
                        return
                }
                
                do {
                    try self.dataBase.saveNewsFeed(newsFeed: rss)
                    self.presenter.endRefreshing()
                    self.presenter.reloadData()
                } catch {
                    self.presenter.endRefreshing()
                    self.presenter.showError(error: error)
                }
            }
        } else {
            self.presenter.endRefreshing()
        }
    }
    
    func addNewUrl() {
        presenter.showSetUrlView(title: title, inputPlaceholder: inputPlaceholder) { textUrl in
            guard let textUrl = textUrl else {
                print("User cancelled action.")
                return
            }
            
            if self.url == "" {
                self.presenter.startLoading()
                self.presenter.hideStartView()
            }
            self.service.getNews(urlString: textUrl) { rss, error in
                guard let rss = rss,
                    error == nil else {
                        self.presenter.endLoading()
                        self.url == "" ? self.presenter.showStartView() : nil
                        self.presenter.showError(error: error!)
                        return
                }
                
                do {
                    try self.dataBase.saveNewsFeed(newsFeed: rss)
                    self.url = textUrl
                    
                    self.presenter.endLoading()
                    self.presenter.updateHeaderInfo(title: rss.title, isEmptyList: false)
                    self.presenter.reloadData()
                } catch {
                    self.presenter.endLoading()
                    self.url == "" ? self.presenter.showStartView() : nil
                    self.presenter.showError(error: error)
                }
            }
        }
    }
    
    func showInfoAboutNewsStream() {
        do {
            var newsFeed = try self.dataBase.getNewsFeed(url: url)
            if newsFeed.url == "" {
                presenter.showError(error: "news feed is empty")
            }
            
            presenter.showAlertWhenButtonClick(title: newsFeed.title, description: newsFeed.desc, okButtonText: openUrl, cancelButtonText: cancel) { openUrl in
                if openUrl {
                    var url = newsFeed.link
                    while (url.last == "/") {
                        url = String(url.dropLast())
                    }
                    self.service.openUrl(with: url)
                }
            }
        } catch {
            presenter.showError(error: error)
        }
    }
    
    func deleteButtonClicked() {
        do {
            var newsFeed = try self.dataBase.getNewsFeed(url: url)
            if newsFeed.url == "" {
                presenter.showError(error: "news feed is empty")
            }
            
            presenter.showAlertWhenButtonClick(title: "", description: "Are you sure you want to delete the news feed [\(newsFeed.title)]?", okButtonText: "Ok", cancelButtonText: cancel) { deleteStream in
                if deleteStream {
                    do {
                        try self.dataBase.deleteNewsFeed(url: newsFeed.url)
                        self.getDefaultNewsFeed()
                        self.presenter.reloadData()
                    } catch {
                        self.presenter.showError(error: error)
                    }
                }
            }
        } catch {
            presenter.showError(error: error)
        }
    }
    
    func cellClicked(index: Int) {
        do {
            var newsFeed = try self.dataBase.getNewsFeed(url: url)
            if newsFeed.url == "" {
                presenter.showError(error: "news feed is empty")
            }
            router.showNewsDetailsViewController(newsItem: newsFeed.news[index])
        } catch {
            presenter.showError(error: error)
        }
    }
    
    func getNewsCount() -> Int {
        do {
            var newsFeed = try self.dataBase.getNewsFeed(url: url)
            if newsFeed.url == "" {
               return 0
            } else {
                return newsFeed.news.count
            }
        } catch {
            presenter.showError(error: error)
            return 0
        }
    }
    
    func getNewsItem(index: Int, completion: @escaping (_ image: UIImage?) -> Void) -> NewsModelProtocol {
        var model = NewsModel(title: "", link: "", desc: "", pubDate: "", author: "", image: nil)
        
        do {
            var newsFeed = try self.dataBase.getNewsFeed(url: url)
            let item = newsFeed.news[index]
            var description = item.desc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            description = description.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range:nil)
            description = description.replacingOccurrences(of: "\r", with: "", options: NSString.CompareOptions.literal, range:nil)
            
            if newsFeed.news[index].image == nil {
                service.loadImage(attributedString: item.desc) { image, error in
                    guard let image = image else {
                        completion(nil)
                        return
                    }
                    
                    do {
                        let newsModel = NewsModel(title: item.title, link: item.link, desc: item.desc, pubDate: item.pubDate, author: item.author, image: image)
                        try self.dataBase.updateNews(news: newsModel)
                    } catch {
                        self.presenter.showError(error: error)
                    }
                    
                    completion(image)
                }
            } else {
                completion(nil)
            }
            
            model.title = item.title
            model.link = item.link
            model.desc = description
            model.pubDate = item.pubDate
            model.author = item.author
            model.image = item.image
        } catch {
            presenter.showError(error: error)
        }
        
        return model
    }
    
}
