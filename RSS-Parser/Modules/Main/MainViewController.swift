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
    private let nibFileName = "FeedCell"
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FeedCell
        let currentLastItem = rssItems[indexPath.row]
        
        cell.selectionStyle = .none
        cell.titleLabel.text = currentLastItem.title
        cell.pubDateLabel.text = currentLastItem.pubDate
        cell.descriptionLabel.text = currentLastItem.description
        cell.imageView!.image = self.imageWithImage(image: #imageLiteral(resourceName: "news"), scaledToSize: CGSize(width: 70, height: 70))
        
        return cell
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
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
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideAI() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func showStartView() {
        self.view.addSubview(emptyListView)
    }
    
    func hideStartView() {
        emptyListView.removeFromSuperview()
    }
    
    func tableBinging() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib.init(nibName: nibFileName, bundle: nil), forCellReuseIdentifier: cellId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setTitle(/*title: String, leftButton: UIBarButtonItem?, rightButtons: [UIBarButtonItem]?*/) {
        self.navigationItem.title = "RSS Parser"
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createCustomButton(name: "menuIcon", selector: #selector(leftClick)))
        self.navigationItem.leftBarButtonItem?.title = ""
        
        let icon1 = UIBarButtonItem(customView: createCustomButton(name: "addIcon", selector: #selector(rightClick)))
        let icon2 = UIBarButtonItem(customView: createCustomButton(name: "deleteIcon", selector: #selector(rightClick)))
        let icon3 = UIBarButtonItem(customView: createCustomButton(name: "infoIcon", selector: #selector(rightClick)))
        
        self.navigationItem.rightBarButtonItems = [icon3, icon2, icon1]
        self.navigationItem.rightBarButtonItem?.title = ""
    }
    
    func createCustomButton(name: String, selector: Selector) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        var img = self.imageWithImage(x: 0, image: UIImage(named: name)!, scaledToSize: CGSize(width: 24, height: 24))
        img = img.withRenderingMode(.alwaysTemplate)
        button.setImage(img, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    func imageWithImage(x: CGFloat, image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: x, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @objc func leftClick(sender: UIBarButtonItem) {
    }
    
    @objc func rightClick(sender: UIBarButtonItem) {
    }
    
    func fetchData(items: [RSSItemModel]) {
        self.rssItems = items
        self.tableView.reloadData()
    }

}

