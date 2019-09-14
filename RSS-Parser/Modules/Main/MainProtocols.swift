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
    func clearHeaderButtons() 
    
    func showLoadingView()
    func hideLoadingView()
    func showStartView()
    func hideStartView()
    
    func setURLView(title: String, inputPlaceholder: String, completion: @escaping (_ text: String?) -> Void)
    func showAlertWhenButtonClick(title: String, description: String, okButtonText: String, cancelButtonText: String, completion: @escaping (_ openUrl: Bool) -> Void)
    func showAlertView(with text: String)
    
    func tableBinging()
    func reloadData()
}

protocol MainPresenterProtocol: class {
    func configureView()
    
    func updateHeaderInfo(title: String, isEmptyList: Bool)
    func startLoading()
    func endLoading()
    func hideStartView()
    func showStartView()
    
    func addUrlButtonClicked()
    func showInfoButtonClicked()
    func deleteButtonClicked()
    func cellClicked(index: Int)
    
    func showSetUrlView(title: String, inputPlaceholder: String, completion: @escaping (_ text: String?) -> Void)
    func showAlertWhenButtonClick(title: String, description: String, okButtonText: String, cancelButtonText: String, completion: @escaping (_ openUrl: Bool) -> Void)
    func getNewsCount() -> Int
    func getNewsItem(index: Int, completion: @escaping (_ image: UIImage?) -> Void) -> NewsModelProtocol
    func reloadData()
    
    func showError(error: Error)
}

protocol MainInteractorProtocol: class {
    var defaultTitle: String { get }
    
    func getDefaultNewsFeed()
    func addNewUrl()
    func showInfoAboutNewsStream()
    func deleteButtonClicked()
    func cellClicked(index: Int)
    func getNewsCount() -> Int
    func getNewsItem(index: Int, completion: @escaping (_ image: UIImage?) -> Void) -> NewsModelProtocol
}

protocol MainRouterProtocol: class {
    func showNewsDetailsViewController(newsItem: NewsModelProtocol)
}

protocol MainConfiguratorProtocol: class {
    func configure(with viewController: MainViewController)
}
