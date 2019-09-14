//
//  MainRouter.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class MainRouter: MainRouterProtocol {
    
    weak var viewController: MainViewController!
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
    
    func closeCurrentViewController() {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func showNewsDetailsViewController(newsItem: NewsModelProtocol) {
        let vc = NewsDetailsViewController(nibName: "NewsDetailsViewController", bundle: nil)
        //vc.modalPresentationStyle = .overFullScreen
        vc.newsItem = newsItem
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        viewController.navigationItem.backBarButtonItem = backItem
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
