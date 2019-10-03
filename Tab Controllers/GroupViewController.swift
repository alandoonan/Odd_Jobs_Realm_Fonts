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
    var notificationToken: NotificationToken?
//    let themes: Results<ThemeItem>
//    let scoreItem: Results<ScoreItem>
    let tableView = UITableView()
    var searchBar = UISearchBar()
    var userID = SyncUser.current?.identity
    let viewScoreCateogry = Constants.groupScoreCategory



    // MARK: Initialize & View Did Load Functions
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_USERS_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items = realm.objects(OddJobItem.self).filter(Constants.groupTaskFilter, viewScoreCateogry,userID!)
//        self.themes = realm.objects(ThemeItem.self).filter("Category contains[c] %@", "Theme")
//        self.scoreItem = realm.objects(ScoreItem.self).filter("Category contains[c] %@", "Life")
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutButtonPress))
        let sideBar = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.automatic), style: .plain, target: self, action: #selector(handleDismiss))
        let addGroupTask = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskPassThrough))
        searchBar.keyboardAppearance = .dark
        tableView.addTableView(tableView, view)
        tableView.dataSource = self
        tableView.delegate = self
        addNotificationToken(items: items, notificationToken: notificationToken)
        setUpSearchBar(searchBar: searchBar)
        addNavBar([sideBar],[addGroupTask],scoreCategory: viewScoreCateogry)
        addSearchBar(scoreCategory: viewScoreCateogry, searchBar: searchBar)
        applyTheme(tableView,view)
        tableView.reloadData()
        hideKeyboardWhenTappedAround()

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: Notification Token
    func addNotificationToken(items: Results<OddJobItem>, notificationToken: NotificationToken?) {
        self.notificationToken = items.observe { [weak self] (changes) in
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
    
    // MARK: TableView Functions
    // MARK: This is in all classes (REFACTOR)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        try! realm.write {
            item.IsDone = !item.IsDone
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return addTableCell(tableView, indexPath, Constants.cellFields, items: items)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        deleteOddJob(indexPath, realm: realm, items: items)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = UIContextualAction(style: .normal, title: Constants.doneSwipe) { (action, view, completionHandler) in
            completionHandler(true)
            print("Swiping")
            self.doneGroupOddJob(indexPath, realm: self.realm, items: self.items, tableView: self.tableView)
        }
        done.backgroundColor = Themes.current.done
        let config = UISwipeActionsConfiguration(actions: [done])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    //MARK: Search Bar Functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("typing in search bar: term = \(searchText)")
        if searchText != "" {
            let predicate = NSPredicate(format:Constants.searchFilter, searchText, searchText, viewScoreCateogry, (SyncUser.current?.identity)!)
            self.items = realm.objects(OddJobItem.self).filter(predicate)
            tableView.reloadData()
        } else {
            self.items = realm.objects(OddJobItem.self).filter(Constants.groupTaskFilter, viewScoreCateogry, (SyncUser.current?.identity)!)
            tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    //MARK: Selector/Action Functions
    @objc func addTaskPassThrough() {
        presentTaskCreateController(storyBoardID: "CreateTaskViewController", taskType: "Group")
    }
}
