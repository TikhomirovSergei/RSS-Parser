//
//  NewsItemProtocol.swift
//  RSS-Parser
//
//  Created by Сергей on 12/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

protocol NewsItemModel {
    var title: String { get set }
    var link: String { get set }
    var description: String { get set }
    var pubDate: String { get set }
    var author: String { get set }
    var imageUrl: String? { get set }
}
