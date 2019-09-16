//
//  NewsDetailsProtocols.swift
//  RSS-Parser
//
//  Created by Сергей on 12/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

protocol NewsDetailsViewProtocol: class {
    func showAlertView(with text: String)
}

protocol NewsDetailsPresenterProtocol: class {    
    func configureView()
    func setViewTitle() -> String
    func getSelectedNews(completion: @escaping (_ image: UIImage?) -> Void) -> NewsModelProtocol?
    func readMoreClicked()
    func showError(error: String)
}

protocol NewsDetailsInteractorProtocol: class {
    func setViewTitle() -> String
    func getSelectedNews(completion: @escaping (_ image: UIImage?) -> Void) -> NewsModelProtocol?
    func readMoreClicked()
}

protocol NewsDetailsRouterProtocol: class {
    func closeViewController()
}

protocol NewsDetailsConfiguratorProtocol: class {
    func configure(with viewController: NewsDetailsViewController)
}
