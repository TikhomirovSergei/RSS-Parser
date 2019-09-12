//
//  RSSItemModel.swift
//  RSS-Parser
//
//  Created by Сергей on 11/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

struct RSSItemModel: NewsItemModel {
    var title: String
    var link: String
    var description: String
    var pubDate: String
    var author: String
    var imageUrl: String?
}
