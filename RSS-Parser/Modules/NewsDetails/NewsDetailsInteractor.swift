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
        
        self.loadImage(news: newsItem) { image in
            completion(image)
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
            thumbnail: newsItem.thumbnail,
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
    
    private func loadImage(news: NewsModelProtocol, completion: @escaping (_ image: UIImage?) -> Void) {
        if news.image == nil {
            if news.thumbnail != "" {
                service.loadImageFromUrl(url: news.thumbnail) { image, error in
                    guard let image = image, error == nil else {
                        self.presenter.showError(error: error!.localizedDescription)
                        completion(nil)
                        return
                    }
                    
                    self.saveImage(news: news, image: image)
                    completion(image)
                }
            } else {
                service.loadImage(attributedString: news.desc) { image, error in
                    guard let image = image else {
                        if error != nil {
                            self.presenter.showError(error: error!.localizedDescription)
                        }
                        completion(nil)
                        return
                    }
                    
                    self.saveImage(news: news, image: image)
                    completion(image)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    private func saveImage(news: NewsModelProtocol, image: UIImage) {
        do {
            let newsModel = NewsModel(title: news.title, link: news.link, desc: news.desc, pubDate: news.pubDate, author: news.author, thumbnail: news.thumbnail, image: image)
            try self.dataBase.updateNews(url: dataBase.getSelectedUrl(), news: newsModel)
        } catch {
            self.presenter.showError(error: error.localizedDescription)
        }
    }
    
}
