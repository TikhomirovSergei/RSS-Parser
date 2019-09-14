//
//  NewsFeedModel.swift
//  RSS-Parser
//
//  Created by Сергей on 11/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

struct NewsFeedModel: NewsFeedModelProtocol {
    var url: String
    var title: String
    var link: String
    var desc: String
    var news: [NewsModelProtocol]
}
