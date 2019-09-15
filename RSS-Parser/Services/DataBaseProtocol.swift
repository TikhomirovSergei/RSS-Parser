//
//  DataBaseProtocol.swift
//  RSS-Parser
//
//  Created by Сергей on 13/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

protocol DataBaseProtocol: class {
    func setSelectedNews(news: NewsModelProtocol)
    func getSelectedNews() -> NewsModelProtocol?
    func setSelectedUrl(selectedUrl: String)
    func getSelectedUrl() -> String
    func setMenuIsOpen(menuIsOpen: Bool)
    func getMenuIsOpen() -> Bool
    func saveNewsFeed(newsFeed: NewsFeedModelProtocol) throws
    func deleteNewsFeed(url: String) throws
    func updateNews(news: NewsModelProtocol) throws
    func getNewsFeed(url: String) throws -> NewsFeedModelProtocol
    func getNewsFeeds() throws -> [NewsFeedModelProtocol]
}
