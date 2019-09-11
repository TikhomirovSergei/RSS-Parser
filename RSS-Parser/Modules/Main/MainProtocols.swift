//
//  MainProtocols.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

protocol MainViewProtocol: class {
    func setURLView(title: String, inputPlaceholder: String, completion: @escaping (_ text: String?) -> Void)
    func showAlertView(with text: String)
    func showAI()
    func hideAI()
    func showStartView()
    func hideStartView()
    func tableBinging()
    func fetchData(items: [RSSItemModel])
    func setTitle()
}

protocol MainPresenterProtocol: class {
    var router: MainRouterProtocol! { set get }
    func configureView()
    func addRSSButtonClicked()
    
    func closeButtonClicked()
    func urlButtonClicked(with urlString: String?)
}

protocol MainInteractorProtocol: class {
    func openUrl(with urlString: String)
    func getFeeds(with urlString: String, completion: @escaping ([RSSItemModel]?, Error?) -> Void)
}

protocol MainRouterProtocol: class {
    func closeCurrentViewController()
}

protocol MainConfiguratorProtocol: class {
    func configure(with viewController: MainViewController)
}
