//
//  NewsModel.swift
//  RSS-Parser
//
//  Created by Сергей on 11/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

struct NewsModel: NewsModelProtocol {
    var title: String
    var link: String
    var desc: String
    var pubDate: String
    var author: String
    var thumbnail: String
    var image: UIImage?
}
