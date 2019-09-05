//
//  ItemsViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift
import RealmSearchViewController
import RSSelectionMenu
class PersonalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{

    // Class Variables
    var realm: Realm
    var items: Results<OddJobItem>
    var sorts : Results<OddJobItem>!
    var scoreVC = ScoreViewController()
    var notificationToken: NotificationToken?
    var delegate: HomeControllerDelegate?
    var searchBar = UISearchBar()
    let tableView = UITableView()
    var scoreCategory = ["Personal"]

    // Initialize Realm
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items = realm.objects(OddJobItem.self).filter("Category contains[c] %@", scoreCategory[0])
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        notificationToken?.invalidate()
    }
    
    // View Load & Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        applyTheme(tableView,view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutButtonPress))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskPassThrough))
        let sideBar = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        addSearchBar(scoreCategory: scoreCategory, searchBar: searchBar)
        addNavBar([sideBar, add], [logout], scoreCategory: scoreCategory)
        tableView.addTableView(tableView, view)
        tableView.dataSource = self
        tableView.delegate = self
        addNotificationToken()
        setUpSearchBar(searchBar: searchBar)
        applyTheme(tableView,view)
        tableView.reloadData()
    }
    
     //Add UI & Customization Functions
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }
    
    // Realm Class Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oddJobitem = items[indexPath.row]
        try! realm.write {
            oddJobitem.IsDone = !oddJobitem.IsDone
        }
        if oddJobitem.IsDone == true {
            print("+1")
            updateScore(realm: realm)
        }
    }
    func addTableCell(_ tableView: UITableView, _ indexPath: IndexPath, _ cellFields:[String]) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cellSetup(cell, item, Constants.cellFields)
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return addTableCell(tableView, indexPath, Constants.cellFields)
    }
    
    // Sorting Functions & Menu
    fileprivate func rssSelectionMenuSort() {
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(dataSource: Constants.sortFields) { (cell, name, indexPath) in
            cell.textLabel?.text = name
            cell.textLabel?.textColor = .white
            cell.backgroundColor = Themes.current.background
        }
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            self.sortOddJobs(sort: String(selectedItems[0]))
        }
        menu.show(style: .push, from: self)
    }
    @objc func selectSortField() {
        print("Sort Button Pressed")
        rssSelectionMenuSort()
    }
    @objc func sortOddJobs(sort:String) {
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
    
    @objc func addTaskPassThrough() {
        showStoryBoardView(storyBoardID: "CreateTaskViewController")
        //addTaskAlert(realm: realm,scoreCategory: scoreCategory)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let item = items[indexPath.row]
        try! realm.write {
            realm.delete(item)
        }
    }
}
