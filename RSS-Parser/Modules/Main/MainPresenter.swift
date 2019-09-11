//
//  MainPresenter.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol!
    var interactor: MainInteractorProtocol!
    var router: MainRouterProtocol!
    
    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    // MARK: - MainPresenterProtocol methods
    
    func configureView() {
        view.tableBinging()
    }
    
    func addRSSButtonClicked() {
        view.setURLView(title: "New RSS", inputPlaceholder: "set url") { text in
            
            guard let text = text else {
                print("User cancelled action.")
                return
            }
            
            self.view.hideStartView()
            self.view.showAI()
            self.interactor.getFeeds(with: text) { items, error in
                guard let items = items else {
                    return
                }
                
                self.view.hideAI()
                self.view.setTitle()
                self.view.fetchData(items: items)
            }
        }
    }
    
    func closeButtonClicked() {
        router.closeCurrentViewController()
    }
    
    func urlButtonClicked(with urlString: String?) {
        if let url = urlString {
            interactor.openUrl(with: url)
        }
    }
}
