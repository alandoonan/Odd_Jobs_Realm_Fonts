//
//  SummaryViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 09/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//


import UIKit
import RealmSwift
import RSSelectionMenu
class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    var realm: Realm
    var items: Results<OddJobItem>
    var sorts : Results<OddJobItem>!
    var scoreVC = ScoreViewController()
    var notificationToken: NotificationToken?
    var delegate: HomeControllerDelegate?
    var searchBar = UISearchBar()
    let tableView = UITableView()
    let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutButtonPress))
    let sideBar = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    //let sort = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(selectSortField))
    //let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchOddJobs))
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items = realm.objects(OddJobItem.self).filter(Constants.taskFilter, Constants.listTypes)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        applyTheme(tableView,view)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("typing in search bar: term = \(searchText)")
        if searchText != "" {
            let predicate = NSPredicate(format:Constants.searchFilter, searchText, searchText, Constants.listTypes)
            self.items = realm.objects(OddJobItem.self).filter(predicate)
            tableView.reloadData()
        } else {
            self.items = realm.objects(OddJobItem.self).filter(Constants.taskFilter, Constants.listTypes)
            tableView.reloadData()
        }
        tableView.reloadData()
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
        addSearchBar(scoreCategory: Constants.listTypes, searchBar: searchBar)
        addNavBar([sideBar], [logout], scoreCategory: Constants.listTypes)
        tableView.addTableView(tableView, view)
        tableView.dataSource = self
        tableView.delegate = self
        addNotificationToken()
        addNotificationToken()
        setUpSearchBar(searchBar: searchBar)
        applyTheme(tableView,view)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    fileprivate func isDoneUpdate(_ indexPath: IndexPath) {
        let oddJobitem = items[indexPath.row]
        try! realm.write {
            oddJobitem.IsDone = !oddJobitem.IsDone
        }
        if oddJobitem.IsDone == true {
            updateScore(realm: realm, value: 1, category: oddJobitem.Category)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isDoneUpdate(indexPath)
    }
    
    func addTableCell(_ tableView: UITableView, _ indexPath: IndexPath, _ cellFields:[String]) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cellSetup(cell, item, Constants.cellFields)
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return addTableCell(tableView, indexPath,Constants.cellFields)
    }
    
    fileprivate func rssSelectionSort() {
        print("Sort Button Pressed")
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(dataSource: Constants.sortFields) { (cell, name, indexPath) in
            cell.textLabel?.text = name
            cell.textLabel?.textColor = Themes.current.accent
            cell.backgroundColor = Themes.current.background
        }
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            self.sortOddJobs(sort: String(selectedItems[0]))
        }
        menu.show(style: .push, from: self)
    }
    
    @objc func selectSortField() {
        rssSelectionSort()
    }

    fileprivate func sortTableView(_ sort: String) {
        self.items = self.items.sorted(byKeyPath: sort, ascending: true)
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
    
    @objc func sortOddJobs(sort:String) {
        sortTableView(sort)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        deleteOddJob(indexPath, realm: realm, items: items)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = UIContextualAction(style: .normal, title: Constants.doneSwipe) { (action, view, completionHandler) in
            completionHandler(true)
            self.doneOddJob(indexPath, value: Constants.increaseScore, realm: self.realm, items: self.items)
        }
        done.backgroundColor = Themes.current.done
        let config = UISwipeActionsConfiguration(actions: [done])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
