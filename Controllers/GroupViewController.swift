//
//  ItemsViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift
class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let realm: Realm
    let items: Results<OddJobItem>
    var sorts : Results<OddJobItem>!
    let tableView = UITableView()
    var notificationToken: NotificationToken?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items = realm.objects(OddJobItem.self).filter("Category contains[c] %@", "Group")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    @objc func searchOddJobs() {
        print("Search Button Pressed")
    }
    
    fileprivate func addNavItem(_ add: UIBarButtonItem,_ sideBar: UIBarButtonItem, _ logout: UIBarButtonItem, _ search: UIBarButtonItem) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidClick))
        //navigationItem.rightBarButtonItems = [sideBar] //, logout,search
        navigationItem.leftBarButtonItems = [sideBar, add] //, logout,search
        navigationItem.title = "Group Odd Jobs"
    }
    
    fileprivate func addTableView() {
        tableView.backgroundColor = UIColor.navyTheme
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.frame = self.view.frame
        view.addSubview(tableView)
    }
    
    fileprivate func addNotificationToken() {
        notificationToken = items.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(rightBarButtonDidClick))
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchOddJobs))
        let sideBar = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidClick))
        addNavItem(add, sideBar, logout, search)
        addTableView()
        addNotificationToken()
    }
    
    fileprivate func logoutAlert() {
        let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "Yes, Logout", style: .destructive, handler: {
            alert -> Void in
            SyncUser.current?.logOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func rightBarButtonDidClick() {
        logoutAlert()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        try! realm.write {
            item.IsDone = !item.IsDone
        }
    }
    
    fileprivate func addTableCell(_ cell: UITableViewCell, _ item: OddJobItem) -> UITableViewCell {
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.blueTheme
        cell.textLabel?.text = item.Name
        cell.tintColor = .white
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.text = ("Priority: " + item.Priority)
        cell.detailTextLabel?.text = ("Occurence: " + item.Occurrence)
        cell.accessoryType = item.IsDone ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let item = items[indexPath.row]
        return addTableCell(cell, item)
    }
    
    fileprivate func addAlert() {
        let alertController = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let oddJobName = alertController.textFields![0] as UITextField
            let oddJobPriority = alertController.textFields![1] as UITextField
            let oddJobOccurrence = alertController.textFields![2] as UITextField
            let item = OddJobItem()
            item.Name = oddJobName.text ?? ""
            item.Priority = oddJobPriority.text ?? ""
            item.Occurrence = oddJobOccurrence.text ?? ""
            item.Category = "Group"
            try! self.realm.write {
                self.realm.add(item)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: {(oddJobName : UITextField!) -> Void in
            oddJobName.placeholder = "Odd Job Name"
        })
        alertController.addTextField(configurationHandler: {(oddJobPriority : UITextField!) -> Void in
            oddJobPriority.placeholder = "Odd Job Priority"
        })
        alertController.addTextField(configurationHandler: {(oddJobOccurrence : UITextField!) -> Void in
            oddJobOccurrence.placeholder = "Odd Job Occurrence"
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func addButtonDidClick() {
        addAlert()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let item = items[indexPath.row]
        try! realm.write {
            realm.delete(item)
        }
    }
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_clear_white_36pt_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
}
