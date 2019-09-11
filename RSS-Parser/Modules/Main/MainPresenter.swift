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
        self.view.setTitle(title: "RSS parser")
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
            self.interactor.getNews(with: text) { rss, error in
                guard let rss = rss,
                    error == nil else {
                        self.view.hideAI()
                        self.view.showStartView()
                        self.view.showAlertView(with: error!.localizedDescription)
                        return
                }
                
                self.view.hideAI()
                self.view.setTitle(title: rss.title)
                self.view.showMenuButton()
                self.view.showRightBarButtons()
                self.view.fetchData(items: rss.items)
            }
        }
    }
    
}
