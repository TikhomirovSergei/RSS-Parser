//
//  MenuRouter.swift
//  RSS-Parser
//
//  Created by Сергей on 15/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class MenuRouter: MenuRouterProtocol {
    weak var viewController: MenuViewController!
    
    init(viewController: MenuViewController) {
        self.viewController = viewController
    }
    
}
