//
//  NewsDetailsRouter.swift
//  RSS-Parser
//
//  Created by Сергей on 12/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class NewsDetailsRouter: NewsDetailsRouterProtocol {    
    weak var viewController: NewsDetailsViewController!
    
    init(viewController: NewsDetailsViewController) {
        self.viewController = viewController
    }
    
    func closeViewController() {
        viewController.navigationController?.popViewController(animated: true)
    }
    
}
