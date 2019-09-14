//
//  NewsDetailsInteractor.swift
//  RSS-Parser
//
//  Created by Сергей on 12/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

class NewsDetailsInteractor: NewsDetailsInteractorProtocol {
    weak var presenter: NewsDetailsPresenterProtocol!
    var router: NewsDetailsRouterProtocol!
    let service: ServiceProtocol = Service()
    
    private var item: NewsModelProtocol = NewsModel(title: "", link: "", desc: "", pubDate: "", author: "", image: nil)
    
    required init(presenter: NewsDetailsPresenterProtocol) {
        self.presenter = presenter
    }
    
    func setNewsItem(newsItem: NewsModelProtocol) {
        self.item = newsItem        
    }
}
