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

    @IBOutlet var image: UIImageView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var pubDateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var readMoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = presenter.setViewTitle()
        
        let selectedNews = presenter.getSelectedNews() { image in
            guard let image = image else {
                return
            }
            
            self.image.image = image
        }
        
        guard let newsItem = selectedNews else {
            return
        }
        
        image.image = newsItem.image == nil ? UIImage(#imageLiteral(resourceName: "news")) : newsItem.image
        titleLabel.text = newsItem.title
        authorLabel.text = newsItem.author
        pubDateLabel.text = newsItem.pubDate
        descriptionLabel.text = newsItem.desc
    }

    @IBAction func readMoreButtonAction(_ sender: Any) {
        presenter.readMoreClicked()
    }
}
