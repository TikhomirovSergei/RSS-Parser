//
//  NewsDetailsInteractor.swift
//  RSS-Parser
//
//  Created by Сергей on 12/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class NewsDetailsInteractor: NewsDetailsInteractorProtocol {
    private let viewTitle = "News details"
    weak var presenter: NewsDetailsPresenterProtocol!
    var router: NewsDetailsRouterProtocol!
    let service: ServiceProtocol = Service()
    let dataBase: DataBaseProtocol = DataBase()
    
    required init(presenter: NewsDetailsPresenterProtocol) {
        self.presenter = presenter
    }
    
    func setViewTitle() -> String {
        return viewTitle
    }
    
    func getSelectedNews(completion: @escaping (_ image: UIImage?) -> Void) -> NewsModelProtocol? {
        let news = dataBase.getSelectedNews()
        
        guard let newsItem = news else {
            router.closeViewController()
            return nil
        }
        
        if newsItem.image == nil {
            service.loadImage(attributedString: newsItem.desc) { image, error in
                guard let image = image else {
                    completion(nil)
                    return
                }
                
                do {
                    let newsModel = NewsModel(title: newsItem.title, link: newsItem.link, desc: newsItem.desc, pubDate: newsItem.pubDate, author: newsItem.author, image: image)
                    try self.dataBase.updateNews(news: newsModel)
                } catch {
                    print("Failed to save news picture in database.")
                }
                
                completion(image)
            }
        } else {
            completion(nil)
        }
        
        var desc = newsItem.desc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        desc = desc.replacingOccurrences(of: "\r\n", with: "\n\t", options: NSString.CompareOptions.literal, range:nil)
        desc = desc.replacingOccurrences(of: "Читать дальше →", with: "", options: NSString.CompareOptions.literal, range:nil)
        desc = desc.replacingOccurrences(of: " \n ", with: "", options: NSString.CompareOptions.literal, range:nil)
        desc = desc.replacingOccurrences(of: "  ", with: "", options: NSString.CompareOptions.literal, range:nil)
        
        let model = NewsModel(
            title: newsItem.title,
            link: newsItem.link,
            desc: desc,
            pubDate: newsItem.pubDate,
            author: newsItem.author,
            image: newsItem.image)
        
        return model
    }
    
    func readMoreClicked() {
        let news = dataBase.getSelectedNews()
        
        guard let newsItem = news else {
            return
        }
        
        var link = newsItem.link.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range:nil)
        link = link.replacingOccurrences(of: "  ", with: "", options: NSString.CompareOptions.literal, range:nil)
        
        service.openUrl(with: link)
    }
}
