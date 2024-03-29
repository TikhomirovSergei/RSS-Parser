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
    private var refreshTime = Date(timeIntervalSince1970: 0)
    private var selectedNewsFeeds: NewsFeedModelProtocol = NewsFeedModel(url: "", title: "", link: "", desc: "", news: [])
    
    required init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateVC(_:)), name: NSNotification.Name(rawValue: "updateVC"), object: nil)
    }
    
    func getDefaultNewsFeed() {
        do {
            let newsFeeds = try dataBase.getNewsFeeds()
            if newsFeeds.count > 0 {
                dataBase.setSelectedUrl(selectedUrl: newsFeeds[0].url)
                dataBase.getNewsFeed(url: newsFeeds[0].url) { newsFeeds, error in
                    guard let newsFeeds = newsFeeds, error == nil else {
                        self.dataBase.setSelectedUrl(selectedUrl: "")
                        self.presenter.showStartView()
                        self.presenter.updateHeaderInfo(title: self.defaultTitle, isEmptyList: true)
                        return
                    }
                    
                    self.selectedNewsFeeds = newsFeeds
                    self.presenter.reloadData()
                }
                self.presenter.startLoading()
                self.refreshData(timer: -1)
                self.presenter.endLoading()
                self.presenter.hideStartView()
                self.presenter.updateHeaderInfo(title: newsFeeds[0].title, isEmptyList: false)
            } else {
                dataBase.setSelectedUrl(selectedUrl: "")
                self.presenter.showStartView()
                self.presenter.updateHeaderInfo(title: defaultTitle, isEmptyList: true)
            }
        } catch {
            self.presenter.showStartView()
            presenter.showError(error: error)
            self.presenter.updateHeaderInfo(title: defaultTitle, isEmptyList: true)
        }
    }
    
    func refreshData(timer: Int) {
        let diff = Int(Date().timeIntervalSince1970 - refreshTime.timeIntervalSince1970)
        if diff >= timer {
            refreshTime = Date()
            self.service.getNews(urlString: dataBase.getSelectedUrl()) { rss, error in
                guard let rss = rss,
                    error == nil else {
                        self.presenter.showError(error: error!)
                        self.presenter.endRefreshing()
                        return
                }
                
                do {
                    try self.dataBase.saveNewsFeed(newsFeed: rss)
                    self.dataBase.getNewsFeed(url: self.dataBase.getSelectedUrl()) { newsFeeds, error in
                        guard let newsFeeds = newsFeeds, error == nil else {
                            self.presenter.endRefreshing()
                            self.presenter.showError(error: error!)
                            return
                        }
                        
                        self.selectedNewsFeeds = newsFeeds
                        
                        self.postNotificationToUpdateSideMenu()
                        self.presenter.endRefreshing()
                        self.presenter.reloadData()
                    }
                } catch {
                    self.presenter.endRefreshing()
                    self.presenter.showError(error: error)
                }
            }
        } else {
            self.presenter.endRefreshing()
        }
    }
    
    func menuClicked() {
        if dataBase.getMenuIsOpen() {
            dataBase.setMenuIsOpen(menuIsOpen: false)
            presenter.hideSideMenu()
        } else {
            dataBase.setMenuIsOpen(menuIsOpen: true)
            presenter.showSideMenu()
        }
    }
    
    func addNewUrl() {
        presenter.showSetUrlView(title: title, inputPlaceholder: inputPlaceholder) { textUrl in
            guard let textUrl = textUrl else {
                print("User cancelled action.")
                return
            }
            
            if self.dataBase.getSelectedUrl() == "" {
                self.presenter.startLoading()
                self.presenter.hideStartView()
            }
            self.service.getNews(urlString: textUrl) { rss, error in
                guard let rss = rss,
                    error == nil else {
                        self.presenter.endLoading()
                        self.dataBase.getSelectedUrl() == "" ? self.presenter.showStartView() : nil
                        self.presenter.showError(error: error!)
                        return
                }
                
                do {
                    try self.dataBase.saveNewsFeed(newsFeed: rss)
                    self.postNotificationToUpdateSideMenu()
                    self.dataBase.setSelectedUrl(selectedUrl: textUrl)
                    self.dataBase.getNewsFeed(url: textUrl) { newsFeeds, error in
                        guard let newsFeeds = newsFeeds, error == nil else {
                            self.dataBase.setSelectedUrl(selectedUrl: "")
                            self.presenter.showStartView()
                            self.presenter.updateHeaderInfo(title: self.defaultTitle, isEmptyList: true)
                            return
                        }
                        
                        self.selectedNewsFeeds = newsFeeds
                        self.presenter.endLoading()
                        self.presenter.updateHeaderInfo(title: rss.title, isEmptyList: false)
                        self.presenter.reloadData()
                    }
                } catch {
                    self.presenter.endLoading()
                    self.dataBase.getSelectedUrl() == "" ? self.presenter.showStartView() : nil
                    self.presenter.showError(error: error)
                }
            }
        }
    }
    
    func showInfoAboutNewsStream() {
        if selectedNewsFeeds.url == "" {
            presenter.showError(error: "news feed is empty")
        }
        
        presenter.showAlertWhenButtonClick(title: selectedNewsFeeds.title, description: selectedNewsFeeds.desc, okButtonText: openUrl, cancelButtonText: cancel) { openUrl in
            if openUrl {
                var url = self.selectedNewsFeeds.link
                while (url.last == "/") {
                    url = String(url.dropLast())
                }
                self.service.openUrl(with: url)
            }
        }
    }
    
    func deleteButtonClicked() {
        if selectedNewsFeeds.url == "" {
            presenter.showError(error: "news feed is empty")
        }
        
        presenter.showAlertWhenButtonClick(title: "", description: "Are you sure you want to delete the news feed [\(selectedNewsFeeds.title)]?", okButtonText: "Ok", cancelButtonText: cancel) { deleteStream in
            if deleteStream {
                do {
                    try self.dataBase.deleteNewsFeed(url: self.selectedNewsFeeds.url)
                    self.postNotificationToUpdateSideMenu()
                    self.getDefaultNewsFeed()
                } catch {
                    self.presenter.showError(error: error)
                }
            }
        }
    }
    
    func cellClicked(index: Int) {
        if selectedNewsFeeds.url == "" {
            presenter.showError(error: "news feed is empty")
        }
        self.dataBase.setSelectedNews(news: selectedNewsFeeds.news[index])
        router.showNewsDetailsViewController()
        dataBase.setMenuIsOpen(menuIsOpen: false)
        presenter.hideSideMenu()
    }
    
    func getNewsCount() -> Int {
        return selectedNewsFeeds.url == ""
            ? 0
            : selectedNewsFeeds.news.count
    }
    
    func getNewsItem(index: Int, completion: @escaping (_ image: UIImage?) -> Void) -> NewsModelProtocol {
        var model = NewsModel(title: "", link: "", desc: "", pubDate: "", author: "", thumbnail: "", image: nil)
        
        let item = selectedNewsFeeds.news[index]
        var description = item.desc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        description = description.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range:nil)
        description = description.replacingOccurrences(of: "\r", with: "", options: NSString.CompareOptions.literal, range:nil)
        
        self.loadImage(news: item) { image in
            completion(image)
        }
        
        model.title = item.title
        model.link = item.link
        model.desc = description
        model.pubDate = item.pubDate
        model.author = item.author
        model.image = item.image
        
        return model
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
            try self.dataBase.updateNews(url: self.dataBase.getSelectedUrl(), news: newsModel)
        } catch {
            self.presenter.showError(error: error.localizedDescription)
        }
    }
    
    private func postNotificationToUpdateSideMenu() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateSideMenu"), object: nil, userInfo: nil)
    }
    
    @objc private func updateVC(_ notification: NSNotification) {
        do {
            let newsFeeds = try dataBase.getNewsFeeds()
            let selectedUrl = dataBase.getSelectedUrl()
            let selectedNewsFeed = newsFeeds.filter { $0.url == selectedUrl }
            
            if selectedNewsFeed.count > 0 {
                dataBase.getNewsFeed(url: selectedNewsFeed[0].url) { newsFeeds, error in
                    guard let newsFeeds = newsFeeds, error == nil else {
                        self.dataBase.setSelectedUrl(selectedUrl: "")
                        self.presenter.showStartView()
                        self.presenter.updateHeaderInfo(title: self.defaultTitle, isEmptyList: true)
                        return
                    }
                    
                    self.presenter.updateHeaderInfo(title: selectedNewsFeed[0].title, isEmptyList: false)
                    self.selectedNewsFeeds = newsFeeds
                    self.presenter.reloadData()
                }
            }
        } catch {
            presenter.showError(error: error)
        }
        
        if dataBase.getMenuIsOpen() {
            dataBase.setMenuIsOpen(menuIsOpen: false)
            presenter.hideSideMenu()
        } else {
            dataBase.setMenuIsOpen(menuIsOpen: true)
            presenter.showSideMenu()
        }
        
        refreshTime = Date(timeIntervalSince1970: 0)
    }
    
}
