//
//  NewsDetailsPresenter.swift
//  RSS-Parser
//
//  Created by Сергей on 12/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class NewsDetailsPresenter: NewsDetailsPresenterProtocol {    
    weak var view: NewsDetailsViewProtocol!
    var interactor: NewsDetailsInteractorProtocol!
    
    required init(view: NewsDetailsViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        
    }
    
    func setViewTitle() -> String {
        return interactor.setViewTitle()
    }
    
    func getSelectedNews(completion: @escaping (_ image: UIImage?) -> Void) -> NewsModelProtocol? {
        return interactor.getSelectedNews() { image in
            completion(image)
        }
    }
    
    func readMoreClicked() {
        interactor.readMoreClicked()
    }
    
    func showError(error: String) {
        self.view.showAlertView(with: error)
    }
}
