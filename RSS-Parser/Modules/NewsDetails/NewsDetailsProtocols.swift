//
//  NewsDetailsProtocols.swift
//  RSS-Parser
//
//  Created by Сергей on 12/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

protocol NewsDetailsViewProtocol: class {
}

protocol NewsDetailsPresenterProtocol: class {    
    func configureView()
    func setNewsItem(newsItem: NewsModelProtocol)
}

protocol NewsDetailsInteractorProtocol: class {
    func setNewsItem(newsItem: NewsModelProtocol)
}

protocol NewsDetailsRouterProtocol: class {
}

protocol NewsDetailsConfiguratorProtocol: class {
    func configure(with viewController: NewsDetailsViewController)
}
