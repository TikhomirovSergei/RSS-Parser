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
    
    // MARK: - ServiceProtocol methods
    
    func getNews(urlString: String, completion: @escaping (NewsFeedModel?, Error?) -> Void) {
        if let URL = URL(string: urlString) {
            getRSSModel(URL: URL, completion: completion)
        }
    }
    
    func openUrl(with urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func loadImage(attributedString: String, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        DispatchQueue.global().async {
            var image: UIImage? = nil
            do {
                let attributedString = try NSAttributedString(data: attributedString.data(using: .unicode, allowLossyConversion: true)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                
                attributedString.enumerateAttribute(NSAttributedString.Key.attachment, in: NSRange(location: 0, length: attributedString.length), options: []) { value,range,stop in
                    if (value is NSTextAttachment) {
                        let attachment: NSTextAttachment? = (value as? NSTextAttachment)
                        
                        if ((attachment?.image) != nil) {
                            image = attachment?.image
                        } else {
                            image = attachment?.image(forBounds: (attachment?.bounds)!, textContainer: nil, characterIndex: range.location)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(image, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func loadImageFromUrl(url: String, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        DispatchQueue.global().async {
            Alamofire.request(url).validate().response { response in
                guard let data = response.data,
                    let image = UIImage(data: data) else {
                        DispatchQueue.main.async {
                            completion(nil, "image not loaded.")
                        }
                        return
                }
                
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func getRSSModel(URL: URL, completion: @escaping (NewsFeedModel?, Error?) -> Void) {
        DispatchQueue.global().async {
            Alamofire.request(URL.absoluteString, method: .get).response { response in
                
                if response.response?.statusCode == 200 {
                    guard let data = response.data else {
                        DispatchQueue.main.async {
                            completion(nil, response.error)
                        }
                        return
                    }
                    
                    XMLRSSParser(url: URL.absoluteString).parse(data: data) { rss, error in
                        DispatchQueue.main.async {
                            completion(rss, error)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, response.error)
                    }
                }
            }
        }
    }
    
}
