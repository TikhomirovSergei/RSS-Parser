//
//  NewsDetailsPresenter.swift
//  RSS-Parser
//
//  Created by Сергей on 12/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

class NewsDetailsPresenter: NewsDetailsPresenterProtocol {
    weak var view: NewsDetailsViewProtocol!
    var interactor: NewsDetailsInteractorProtocol!
    
    required init(view: NewsDetailsViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        
    }
    
    func setNewsItem(newsItem: NewsModelProtocol) {
        interactor.setNewsItem(newsItem: newsItem)
    }
}
