//
//  EntitiesProtocols.swift
//  RSS-Parser
//
//  Created by Сергей on 13/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

protocol NewsModelProtocol {
    var title: String { get set }
    var link: String { get set }
    var desc: String { get set }
    var pubDate: String { get set }
    var author: String { get set }
    var image: UIImage? { get set }
}

protocol NewsFeedModelProtocol {
    var url: String { get set }
    var title: String { get set }
    var link: String { get set }
    var desc: String { get set }
    var news: [NewsModelProtocol] { get set }
}
