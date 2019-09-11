//
//  MainProtocols.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

protocol MainViewProtocol: class {
    func setTitle(title: String)
    func showMenuButton()
    func showRightBarButtons()
    
    func showAI()
    func hideAI()
    func showStartView()
    func hideStartView()
    
    func setURLView(title: String, inputPlaceholder: String, completion: @escaping (_ text: String?) -> Void)
    func showAlertView(with text: String)
    
    func tableBinging()
    func fetchData(items: [RSSItemModel])
}

protocol MainPresenterProtocol: class {
    var router: MainRouterProtocol! { set get }
    func configureView()
    func addRSSButtonClicked()
}

protocol MainInteractorProtocol: class {
    func getNews(with urlString: String, completion: @escaping (RSSModel?, Error?) -> Void)
}

protocol MainRouterProtocol: class {
}

protocol MainConfiguratorProtocol: class {
    func configure(with viewController: MainViewController)
}
