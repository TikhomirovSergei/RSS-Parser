//
//  NewsDetailsConfigurator.swift
//  RSS-Parser
//
//  Created by Сергей on 12/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class NewsDetailsConfigurator: NewsDetailsConfiguratorProtocol {
    
    func configure(with viewController: NewsDetailsViewController) {
        let presenter = NewsDetailsPresenter(view: viewController)
        let interactor = NewsDetailsInteractor(presenter: presenter)
        let router = NewsDetailsRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.router = router
    }
    
}
