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
    
    func getNewsItemModel() -> [NewsItemModel] {
        return interactor.getNewsItemModel()
    }
    
    func addUrlButtonClicked() {
        interactor.addNewUrl()
    }
    
    func updateHeaderInfo(title: String, isEmptyList: Bool) {
        self.view.setTitle(title: title)
        if !isEmptyList {
            self.view.showMenuButton()
            self.view.showRightBarButtons()
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
    
    func showError(error: Error) {
        self.view.showAlertView(with: error.localizedDescription)
    }
    
    func showSetUrlView(title: String, inputPlaceholder: String, completion: @escaping (_ text: String?) -> Void) {
        view.setURLView(title: title, inputPlaceholder: inputPlaceholder) { text in
            completion(text)
        }
    }
    
    func reloadData() {
        self.view.reloadData()        
    }
    
}
