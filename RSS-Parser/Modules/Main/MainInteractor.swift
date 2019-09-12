//
//  MainInteractor.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

class MainInteractor: MainInteractorProtocol {
    private let title = "New RSS"
    private let inputPlaceholder = "set url"
    
    weak var presenter: MainPresenterProtocol!
    let serverService: ServiceProtocol = Service()
    
    var defaultTitle = "RSS Parser"
    private var rssItems: [NewsItemModel] = []
    
    required init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
    
    func addNewUrl() {
        presenter.showSetUrlView(title: title, inputPlaceholder: inputPlaceholder) { textUrl in
            guard let textUrl = textUrl else {
                print("User cancelled action.")
                return
            }
            
            self.presenter.startLoading()
            self.getNews(with: textUrl) { rss, error in
                guard let rss = rss,
                    error == nil else {
                        self.presenter.endLoading()
                        self.presenter.showError(error: error!)
                        return
                }
                
                self.rssItems = rss.items
                self.presenter.endLoading()
                self.presenter.updateHeaderInfo(title: rss.title, isEmptyList: false)
                self.presenter.reloadData()
            }
        }
    }
    
    func getNewsItemModel() -> [NewsItemModel] {
        return rssItems
    }
    
    private func getNews(with urlString: String, completion: @escaping (RSSModel?, Error?) -> Void) {
        serverService.getNews(urlString: urlString) { rss, error in
            completion(rss, error)
        }
    }
}
