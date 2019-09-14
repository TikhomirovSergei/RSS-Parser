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
    
    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    // MARK: - MainPresenterProtocol methods
    
    func configureView() {
        view.tableBinging()
        view.addRefreshView()
        interactor.getDefaultNewsFeed()
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
        self.view.showLoadingView()
    }
    
    func endLoading() {
        self.view.hideLoadingView()
    }
    
    func hideStartView() {
        self.view.hideStartView()
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
    
    func cellClicked(index: Int) {
        interactor.cellClicked(index: index)
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
    
    func getNewsCount() -> Int {
        return interactor.getNewsCount()
    }
    
    func getNewsItem(index: Int, completion: @escaping (_ image: UIImage?) -> Void) -> NewsModelProtocol {
        return interactor.getNewsItem(index: index) { image in
            completion(image)
        }
    }
    
    func refreshData() {
        interactor.refreshData()
    }
    
    func endRefreshing() {
        self.view.endRefreshing()
    }
    
    func reloadData() {
        self.view.reloadData()
    }
    
    func showError(error: Error) {
        self.view.showAlertView(with: error.localizedDescription)
    }
    
}
