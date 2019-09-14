//
//  NewsDetailsViewController.swift
//  RSS-Parser
//
//  Created by Сергей on 12/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import UIKit

class NewsDetailsViewController: UIViewController, NewsDetailsViewProtocol {
    var presenter: NewsDetailsPresenterProtocol!
    let configurator: NewsDetailsConfiguratorProtocol = NewsDetailsConfigurator()
    
    var newsItem: NewsModelProtocol = NewsModel(title: "", link: "", desc: "", pubDate: "", author: "", image: nil)

    @IBOutlet var image: UIImageView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var pubDateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = newsItem.title
        
        image.image = newsItem.image
        authorLabel.text = newsItem.author
        pubDateLabel.text = newsItem.pubDate
        
        var description = newsItem.desc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        description = description.replacingOccurrences(of: "\r\n", with: "\n\t", options: NSString.CompareOptions.literal, range:nil)
        description = description.replacingOccurrences(of: "Читать дальше →", with: "", options: NSString.CompareOptions.literal, range:nil)
        description = description.replacingOccurrences(of: " \n ", with: "", options: NSString.CompareOptions.literal, range:nil)
        //description = description.replacingOccurrences(of: "\r", with: "", options: NSString.CompareOptions.literal, range:nil)
        
        descriptionLabel.text = description
    }

}
