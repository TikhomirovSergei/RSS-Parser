//
//  Service.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Service: ServiceProtocol {
    
    // MARK: - ServiceProtocol methods
    
    func getNews(urlString: String, completion: @escaping (RSSModel?, Error?) -> Void) {
        if let URL = URL(string: urlString) {
            getRSSModel(URL: URL, completion: completion)
        }
    }
    
    // MARK: - Private methods
    
    private func getRSSModel(URL: URL, completion: @escaping (RSSModel?, Error?) -> Void) {
        DispatchQueue.global().async {
            Alamofire.request(URL.absoluteString, method: .get).response { response in
                
                if response.response?.statusCode == 200 {
                    guard let data = response.data else {
                        DispatchQueue.main.async {
                            completion(nil, response.error)
                        }
                        return
                    }
                    
                    XMLRSSParser().parse(data: data) { rss, error in
                        DispatchQueue.main.async {
                            completion(rss, error)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, response.error)
                    }
                }
            }
        }
    }
    
}
