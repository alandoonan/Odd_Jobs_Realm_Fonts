//
//  ItemsViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift
class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    let realm: Realm
    var items: Results<OddJobItem>
    var sorts : Results<OddJobItem>!
    let tableView = UITableView()
    var notificationToken: NotificationToken?
    var searchBar = UISearchBar()
    var scoreCategory = ["Group"]
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        applyTheme()
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
    
    fileprivate func applyTheme() {
        view.backgroundColor = Themes.current.background
        tableView.backgroundColor = Themes.current.background
        navigationController?.navigationBar.backgroundColor = Themes.current.background
        let textAttributes = [NSAttributedString.Key.foregroundColor:Themes.current.accent]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("typing in search bar: term = \(searchText)")
        if searchText != "" {
            let predicate = NSPredicate(format:"(Name CONTAINS[c] %@ OR Occurrence CONTAINS[c] %@) AND Category in %@", searchText, searchText, scoreCategory)
            self.items = realm.objects(OddJobItem.self).filter(predicate)
            tableView.reloadData()
        } else {
            self.items = realm.objects(OddJobItem.self).filter("Category in %@", scoreCategory)
            tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    fileprivate func addSearchBar(scoreCategory: [String]) {
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false
        searchBar.placeholder = "Search " + scoreCategory.joined(separator:" ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutButtonPress))
        let sideBar = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidClick))
        tableView.addTableView(tableView, view)
        tableView.dataSource = self
        tableView.delegate = self
        addNotificationToken()
        setUpSearchBar()
        addNavBar([add, sideBar],[logout],scoreCategory: scoreCategory)
        addSearchBar(scoreCategory: scoreCategory)
        addNotificationToken()
        applyTheme()
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
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
    
    @objc func logOutButtonPress() {
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
}
