//
//  MenuViewController.swift
//  RSS-Parser
//
//  Created by Сергей on 15/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController, MenuViewProtocol, UITableViewDelegate, UITableViewDataSource {
    private let cellId = "cellId"
    private let nibFileName = "MenuCell"
    
    var presenter: MenuPresenterProtocol!
    let configurator: MenuConfiguratorProtocol = MenuConfigurator()
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            return try presenter.fillingMenu().count
        } catch {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuCell
        do {
            let items = try presenter.fillingMenu()
            let currentLastItem = items[indexPath.row]
            
            cell.menuItemLabel.text = currentLastItem.title
        } catch { }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.cellClicked(index: indexPath.row)
    }
    
    func tableBinging() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib.init(nibName: nibFileName, bundle: nil), forCellReuseIdentifier: cellId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
}
