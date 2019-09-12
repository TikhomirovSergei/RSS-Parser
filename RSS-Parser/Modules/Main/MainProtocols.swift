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
    var router: MainRouterProtocol! { set get }
    
    func configureView()
    
    func updateHeaderInfo(title: String, isEmptyList: Bool)
    func startLoading()
    func endLoading()
    func showStartView()
    
    func addUrlButtonClicked()
    func showInfoButtonClicked()
    func deleteButtonClicked()
    
    func showSetUrlView(title: String, inputPlaceholder: String, completion: @escaping (_ text: String?) -> Void)
    func showAlertWhenButtonClick(title: String, description: String, okButtonText: String, cancelButtonText: String, completion: @escaping (_ openUrl: Bool) -> Void)
    func getNewsItemModel() -> [NewsItemModel]
    func reloadData()
    
    func showError(error: Error)
}

protocol MainInteractorProtocol: class {
    var defaultTitle: String { get }
    
    func addNewUrl()
    func showInfoAboutNewsStream()
    func deleteButtonClicked()
    func getNewsItemModel() -> [NewsItemModel]
}

protocol MainRouterProtocol: class {
}

protocol MainConfiguratorProtocol: class {
    func configure(with viewController: MainViewController)
}
