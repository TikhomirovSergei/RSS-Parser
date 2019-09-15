//
//  MenuConfigurator.swift
//  RSS-Parser
//
//  Created by Сергей on 15/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class MenuConfigurator: MenuConfiguratorProtocol {
    
    func configure(with viewController: MenuViewController) {
        let presenter = MenuPresenter(view: viewController)
        let interactor = MenuInteractor(presenter: presenter)
        let router = MenuRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.router = router
    }
    
}
