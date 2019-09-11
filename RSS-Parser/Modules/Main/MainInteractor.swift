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
    
    func getNews(with urlString: String, completion: @escaping (RSSModel?, Error?) -> Void) {
        serverService.getNews(urlString: urlString) { rss, error in
            completion(rss, error)
        }
    }
}
