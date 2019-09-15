//
//  MenuPresenter.swift
//  RSS-Parser
//
//  Created by Сергей on 15/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

class MenuPresenter: MenuPresenterProtocol {
    weak var view: MenuViewProtocol!
    var interactor: MenuInteractorProtocol!
    
    required init(view: MenuViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        view.tableBinging()
    }
    
    func fillingMenu() throws -> [NewsFeedModelProtocol] {
        return try interactor.fillingMenu()
    }
    
    func reloadData() {
        self.view.reloadData()
    }
    
    func cellClicked(index: Int) {
        interactor.cellClicked(index: index)
    }
    
}
