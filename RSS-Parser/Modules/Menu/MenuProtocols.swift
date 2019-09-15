//
//  MenuProtocols.swift
//  RSS-Parser
//
//  Created by Сергей on 15/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

protocol MenuViewProtocol: class {
    func tableBinging()
    func reloadData()
}

protocol MenuPresenterProtocol: class {
    func configureView()
    func fillingMenu() throws -> [NewsFeedModelProtocol]
    func reloadData()
    func cellClicked(index: Int)
}

protocol MenuInteractorProtocol: class {
    func fillingMenu() throws -> [NewsFeedModelProtocol]
    func cellClicked(index: Int)
}

protocol MenuRouterProtocol: class {
}

protocol MenuConfiguratorProtocol: class {
    func configure(with viewController: MenuViewController)
}
