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
    
    private let refreshControl = UIRefreshControl()

    @IBOutlet var sideMenu: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyListView: UIView!
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet weak var addRSSButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
        
        sideMenu.layer.borderWidth = 0.3
        sideMenu.layer.borderColor = UIColor.black.cgColor
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNewsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsCell
        let currentLastItem = presenter.getNewsItem(index: indexPath.row) { image in
            if image != nil {
                cell.imageView!.image = self._helper.imageWithImage(image: image!, scaledToSize: CGSize(width: 70, height: 70))
            }
        }
        
        cell.selectionStyle = .none
        cell.titleLabel.text = currentLastItem.title
        cell.pubDateLabel.text = currentLastItem.pubDate
        cell.descriptionLabel.text = currentLastItem.desc
        cell.imageView!.image = currentLastItem.image == nil
            ? _helper.imageWithImage(image: #imageLiteral(resourceName: "news"), scaledToSize: CGSize(width: 70, height: 70))
            : _helper.imageWithImage(image: currentLastItem.image!, scaledToSize: CGSize(width: 70, height: 70))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.cellClicked(index: indexPath.row)
    }

    @IBAction func addRSSButtonClicked(_ sender: Any) {
        presenter.addUrlButtonClicked()
    }
    
    // MARK: - MainViewProtocol methods
    
    func setTitle(title: String) {
        self.navigationItem.title = title
    }
    
    func showMenuButton() {
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: _helper.createCustomButton(view: self, name: "menuIcon", selector: #selector(menuClick)))
    }
    
    func showRightBarButtons() {
        let add = UIBarButtonItem(customView: _helper.createCustomButton(view: self, name: "addIcon", selector: #selector(self.addNewRSSStreamClick)))
        let delete = UIBarButtonItem(customView: _helper.createCustomButton(view: self, name: "deleteIcon", selector: #selector(deleteRSSStreamClick)))
        let info = UIBarButtonItem(customView: _helper.createCustomButton(view: self, name: "infoIcon", selector: #selector(infoAboutRSSStreamClick)))
        
        self.navigationItem.rightBarButtonItems = [info, delete, add]
    }
    
    func clearHeaderButtons() {
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.rightBarButtonItems = []
    }
    
    func showLoadingView() {
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
    }
    
    func hideLoadingView() {
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0
    }
    
    func showStartView() {
        emptyListView.alpha = 1
    }
    
    func hideStartView() {
        emptyListView.alpha = 0
    }
    
    func showSideMenu() {
        self.sideMenu.alpha = 1
    }
    
    func hideSideMenu() {
        self.sideMenu.alpha = 0
    }
    
    func setURLView(title: String, inputPlaceholder: String, completion: @escaping (_ text: String?) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
            
            alert.addTextField {
                $0.placeholder = inputPlaceholder
                $0.text = "https://lenta.ru/rss/news"
                $0.addTarget(alert, action: #selector(alert.urlValidate), for: .editingChanged)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
                completion(nil)
            }
            
            let ok = UIAlertAction(title: "Ok", style: .default) { action in
                
                guard let textField = alert.textFields?.first else {
                    completion(nil)
                    return
                }
                
                completion(textField.text)
            }
            ok.isEnabled = false
            
            alert.addAction(cancel)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertView(with text: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertWhenButtonClick(title: String, description: String, okButtonText: String, cancelButtonText: String, completion: @escaping (_ openUrl: Bool) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: okButtonText, style: .default) { action in
                completion(true)
            })
            
            alert.addAction(UIAlertAction(title: cancelButtonText, style: .cancel) { action in
                completion(false)
            })
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableBinging() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib.init(nibName: nibFileName, bundle: nil), forCellReuseIdentifier: cellId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func addRefreshView() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    func endRefreshing() {
        self.refreshControl.endRefreshing()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    @objc func menuClick(sender: UIBarButtonItem) {
        presenter.menuClicked()
    }
    
    @objc func addNewRSSStreamClick(sender: UIBarButtonItem) {
        presenter.addUrlButtonClicked()
    }
    
    @objc func deleteRSSStreamClick(sender: UIBarButtonItem) {
        presenter.deleteButtonClicked()
    }
    
    @objc func infoAboutRSSStreamClick(sender: UIBarButtonItem) {
        presenter.showInfoButtonClicked()
    }
    
    @objc private func refreshData(_ sender: Any) {
        presenter.refreshData()
    }

}
