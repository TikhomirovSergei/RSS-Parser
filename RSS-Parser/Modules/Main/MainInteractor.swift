//
//  MainInteractor.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

class MainInteractor: MainInteractorProtocol {
    
    weak var presenter: MainPresenterProtocol!
    let serverService: ServiceProtocol = Service()
    
    required init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
    
    func openUrl(with urlString: String) {
        serverService.openUrl(with: urlString)
    }
    
    func getFeeds(with urlString: String, completion: @escaping ([RSSItemModel]?, Error?) -> Void) {
        serverService.getFeeds(urlString: urlString) { items, error in
            completion(items, error)
        }
    }
}
