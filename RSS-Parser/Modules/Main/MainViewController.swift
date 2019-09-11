//
//  ViewController.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MainViewProtocol, UITableViewDelegate, UITableViewDataSource {
    private let cellId = "cellId"
    private let nibFileName = "NewsCell"
    private let _helper = Helper()
    
    var presenter: MainPresenterProtocol!
    let configurator: MainConfiguratorProtocol = MainConfigurator()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyListView: UIView!
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet weak var addRSSButton: UIButton!
    
    private var rssItems: [RSSItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsCell
        let currentLastItem = rssItems[indexPath.row]
        
        cell.selectionStyle = .none
        cell.titleLabel.text = currentLastItem.title
        cell.pubDateLabel.text = currentLastItem.pubDate
        cell.descriptionLabel.text = currentLastItem.description
        cell.imageView!.image = _helper.imageWithImage(image: #imageLiteral(resourceName: "news"), scaledToSize: CGSize(width: 70, height: 70))
        
        return cell
    }
    
    @IBAction func addRSSButtonClicked(_ sender: Any) {
        presenter.addRSSButtonClicked()
    }
    
    // MARK: - MainViewProtocol methods
    
    func setURLView(title: String, inputPlaceholder: String, completion: @escaping (_ text: String?) -> Void) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
            
            alertController.addTextField {
                $0.placeholder = inputPlaceholder
                $0.text = "https://habrahabr.ru/rss/interesting/"
                $0.addTarget(alertController, action: #selector(alertController.urlValidate), for: .editingChanged)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
                completion(nil)
            }
            
            let ok = UIAlertAction(title: "Ok", style: .default) { action in
                
                guard let textField = alertController.textFields?.first else {
                    completion(nil)
                    return
                }
                
                completion(textField.text)
            }
            ok.isEnabled = false
            
            alertController.addAction(cancel)
            alertController.addAction(ok)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertView(with text: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "", message: text, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAI() {
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
    }
    
    func hideAI() {
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0
    }
    
    func showStartView() {
        emptyListView.alpha = 1
    }
    
    func hideStartView() {
        emptyListView.alpha = 0
    }
    
    func tableBinging() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib.init(nibName: nibFileName, bundle: nil), forCellReuseIdentifier: cellId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setTitle(title: String) {
        self.navigationItem.title = title
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    
    func showMenuButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: _helper.createCustomButton(name: "menuIcon", selector: #selector(menuClick)))
    }
    
    func showRightBarButtons() {
        let add = UIBarButtonItem(customView: _helper.createCustomButton(name: "addIcon", selector: #selector(addNewRSSStreamClick)))
        let delete = UIBarButtonItem(customView: _helper.createCustomButton(name: "deleteIcon", selector: #selector(deleteRSSStreamClick)))
        let info = UIBarButtonItem(customView: _helper.createCustomButton(name: "infoIcon", selector: #selector(infoAboutRSSStreamClick)))
        
        self.navigationItem.rightBarButtonItems = [info, delete, add]
    }
    
    @objc func menuClick(sender: UIBarButtonItem) {
    }
    
    @objc func addNewRSSStreamClick(sender: UIBarButtonItem) {
    }
    
    @objc func deleteRSSStreamClick(sender: UIBarButtonItem) {
    }
    
    @objc func infoAboutRSSStreamClick(sender: UIBarButtonItem) {
    }
    
    func fetchData(items: [RSSItemModel]) {
        self.rssItems = items
        self.tableView.reloadData()
    }

}

