//
//  MenuInteractor.swift
//  RSS-Parser
//
//  Created by Сергей on 15/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class MenuInteractor: MenuInteractorProtocol {
    weak var presenter: MenuPresenterProtocol!
    var router: MenuRouterProtocol!
    let service: ServiceProtocol = Service()
    let dataBase: DataBaseProtocol = DataBase()
    
    required init(presenter: MenuPresenterProtocol) {
        self.presenter = presenter
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateSideMenu(_:)), name: NSNotification.Name(rawValue: "updateSideMenu"), object: nil)
    }
    
    func fillingMenu() throws -> [NewsFeedModelProtocol] {
        return try dataBase.getNewsFeeds()
    }
    
    func cellClicked(index: Int) {
        do {
            let newsFeeds = try dataBase.getNewsFeeds()
            dataBase.setSelectedUrl(selectedUrl: newsFeeds[index].url)
        } catch { }
        
        dataBase.setMenuIsOpen(menuIsOpen: true)
        self.postNotificationToUpdateMainVC()
    }
    
    private func postNotificationToUpdateMainVC() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateVC"), object: nil, userInfo: nil)
    }
    
    @objc private func updateSideMenu(_ notification: NSNotification) {
        self.presenter.reloadData()
    }
}
