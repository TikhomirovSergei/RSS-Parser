//
//  MainInteractor.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation

class MainInteractor: MainInteractorProtocol {
    private let title = "New RSS"
    private let inputPlaceholder = "set url"
    private let openUrl = "Open original"
    private let cancel = "Cancel"
    
    weak var presenter: MainPresenterProtocol!
    let service: ServiceProtocol = Service()
    
    var defaultTitle = "RSS Parser"
    private var rss: RSSModel? = nil
    
    required init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
    
    func addNewUrl() {
        presenter.showSetUrlView(title: title, inputPlaceholder: inputPlaceholder) { textUrl in
            guard let textUrl = textUrl else {
                print("User cancelled action.")
                return
            }
            
            self.presenter.startLoading()
            self.getNews(with: textUrl) { rss, error in
                guard let rss = rss,
                    error == nil else {
                        self.presenter.endLoading()
                        self.presenter.showError(error: error!)
                        return
                }
                
                self.rss = rss
                self.presenter.endLoading()
                self.presenter.updateHeaderInfo(title: rss.title, isEmptyList: false)
                self.presenter.reloadData()
            }
        }
    }
    
    func showInfoAboutNewsStream() {
        guard let rss = rss else { return }
        presenter.showAlertWhenButtonClick(title: rss.title, description: rss.description, okButtonText: openUrl, cancelButtonText: cancel) { openUrl in
            if openUrl {
                var url = rss.link
                while (url.last == "/") {
                    url = String(url.dropLast())
                }
                self.service.openUrl(with: url)
            }
        }
    }
    
    func deleteButtonClicked() {
        guard rss != nil else { return }
        presenter.showAlertWhenButtonClick(title: "", description: "Are you sure you want to delete the news feed [\(rss!.title)]?", okButtonText: "Ok", cancelButtonText: cancel) { deleteStream in
            if deleteStream {
                self.rss = nil
                self.presenter.updateHeaderInfo(title: self.defaultTitle, isEmptyList: true)
                self.presenter.showStartView()
                self.presenter.reloadData()
            }
        }
    }
    
    func getNewsItemModel() -> [NewsItemModel] {
        return rss?.items ?? []
    }
    
    private func getNews(with urlString: String, completion: @escaping (RSSModel?, Error?) -> Void) {
        service.getNews(urlString: urlString) { rss, error in
            completion(rss, error)
        }
    }
}
