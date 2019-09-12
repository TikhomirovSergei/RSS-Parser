//
//  ServiceProtocol.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

protocol ServiceProtocol: class {
    func getNews(urlString: String, completion: @escaping (RSSModel?, Error?) -> Void)
    func openUrl(with urlString: String)
}
