//
//  XMLRSSParser.swift
//  RSS-Parser
//
//  Created by Сергей on 11/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class XMLRSSParser: NSObject, XMLParserDelegate {
    private var rss: NewsFeedModel = NewsFeedModel(url: "", title: "", link: "", desc: "", news: [])
    private var currentElement = ""
    private var currentTitle = ""
    private var currentLink = ""
    private var currentDescription = ""
    private var currentPubDate = ""
    private var currentAuthor = ""
    private var currentThumbnail = ""
    
    private var firstTitleElement = ""
    private var isFirstTitleElement = true
    private var firstLinkElement = ""
    private var isFirstLinkElement = true
    private var firstDescriptionElement = ""
    private var isFirstDescriptionElement = true
    var parserCompletionHandler: ((NewsFeedModel?, Error?) -> Void)?
    
    init(url: String) {
        self.rss.url = url
    }
    
    func parse(data: Data, completion: @escaping (NewsFeedModel?, Error?) -> Void) {
        parserCompletionHandler = completion
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentElement == "item" || currentElement == "channel" {
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
            currentPubDate = ""
            currentAuthor = ""
            currentThumbnail = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": do {
            if isFirstTitleElement {
                firstTitleElement += string
                isFirstTitleElement = false
            } else {
                currentTitle += string
            }}
            
        case "link": do {
            if isFirstLinkElement {
                firstLinkElement += string
                isFirstLinkElement = false
            } else {
                currentLink += string
            }}
            
        case "description": do {
            if isFirstDescriptionElement {
                firstDescriptionElement += string
                isFirstDescriptionElement = false
            } else {
                currentDescription += string
            }}
            
        case "pubDate": currentPubDate += string
        case "dc:creator": currentAuthor += string
        case "thumbnail": currentThumbnail += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = NewsModel(
                title: currentTitle, link: currentLink,
                desc: currentDescription, pubDate: currentPubDate,
                author: currentAuthor, thumbnail: currentThumbnail, image: nil)
            
            rss.news += [rssItem]
        } else if elementName == "channel" {
            rss.title = firstTitleElement
            rss.link = firstLinkElement
            rss.desc = firstDescriptionElement
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rss, nil)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        parserCompletionHandler?(nil, parseError)
    }
}
