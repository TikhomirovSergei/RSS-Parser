//
//  MainPresenter.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol!
    var interactor: MainInteractorProtocol!
    var router: MainRouterProtocol!
    
    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    // MARK: - MainPresenterProtocol methods
    
    func configureView() {
        self.view.setTitle(title: interactor.defaultTitle)
        view.tableBinging()
    }
    
    func updateHeaderInfo(title: String, isEmptyList: Bool) {
        self.view.setTitle(title: title)
        if !isEmptyList {
            self.view.showMenuButton()
            self.view.showRightBarButtons()
        } else {
            self.view.clearHeaderButtons()
        }
    }
    
    func startLoading() {
        self.view.hideStartView()
        self.view.showLoadingView()
    }
    
    func endLoading() {
        self.view.hideLoadingView()
    }
    
    func showStartView() {
        self.view.showStartView()
    }
    
    func addUrlButtonClicked() {
        interactor.addNewUrl()
    }
    
    func showInfoButtonClicked() {
        interactor.showInfoAboutNewsStream()
    }
    
    func deleteButtonClicked() {
        interactor.deleteButtonClicked()
    }
    
    func showSetUrlView(title: String, inputPlaceholder: String, completion: @escaping (_ text: String?) -> Void) {
        view.setURLView(title: title, inputPlaceholder: inputPlaceholder) { text in
            completion(text)
        }
    }
    
    func showAlertWhenButtonClick(title: String, description: String, okButtonText: String, cancelButtonText: String, completion: @escaping (_ openUrl: Bool) -> Void) {
        view.showAlertWhenButtonClick(title: title, description: description, okButtonText: okButtonText, cancelButtonText: cancelButtonText) { openUrl in
            completion(openUrl)
        }
    }
    
    func getNewsItemModel() -> [NewsItemModel] {
        return interactor.getNewsItemModel()
    }
    
    func reloadData() {
        self.view.reloadData()
    }
    
    func showError(error: Error) {
        self.view.showAlertView(with: error.localizedDescription)
    }
    
}
