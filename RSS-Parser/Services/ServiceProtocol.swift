//
//  ServiceProtocol.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

protocol ServiceProtocol: class {
    func openUrl(with urlString: String)
    func getFeeds(urlString: String, completion: @escaping ([RSSItemModel]?, Error?) -> Void)
}
