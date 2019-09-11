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
    
    // MARK: - ServerServiceProtocol methods
    
    func openUrl(with urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func getFeeds(urlString: String, completion: @escaping ([RSSItemModel]?, Error?) -> Void) {
        if let URL = URL(string: urlString) {
            getJSON(URL: URL, completion: completion)
        }
    }
    
    // MARK: - Private methods
    
    private func getJSON(URL: URL, completion: @escaping ([RSSItemModel]?, Error?) -> Void) {
        Alamofire.request(URL.absoluteString, method: .get).response { response in
            
            guard let data = response.data else {
                /*guard error == nil else {
                    completion(nil, error)
                    return
                }
                */
                completion(nil, "data is nil" as? Error)
                return
            }
            
            FeedParser().parse(data: data) { rssItems, error in
                completion(rssItems, error)
            }
        }
    }
    
}

struct RSSItemModel {
    var title: String
    var description: String
    var pubDate: String
}

class FeedParser: NSObject, XMLParserDelegate {
    private var rssItems: [RSSItemModel] = []
    private var currentElement = ""
    private var currentTitle: String = ""
    private var currentDescription: String = ""
    private var currentPubDate: String = ""
    var parserCompletionHandler: (([RSSItemModel]?, Error?) -> Void)?
    
    func parse(data: Data, completion: @escaping ([RSSItemModel]?, Error?) -> Void) {
        parserCompletionHandler = completion
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "description": do {
            let str = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            currentDescription += str
        }
        case "pubDate": currentPubDate += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItemModel(title: currentTitle, description: currentDescription, pubDate: currentPubDate)
            rssItems += [rssItem]
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems, nil)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        parserCompletionHandler?(nil, parseError)
    }
}
