//
//  ServiceProtocol.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

protocol ServiceProtocol: class {
    func getNews(urlString: String, completion: @escaping (NewsFeedModelProtocol?, Error?) -> Void)
    func openUrl(with urlString: String)
    func loadImage(attributedString: String, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void)
    func loadImageFromUrl(url: String, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void)
}
