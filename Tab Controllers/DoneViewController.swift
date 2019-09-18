//
//  DoneViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 08/09/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift
import RealmSearchViewController
import RSSelectionMenu
class DoneViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource
{
    
    // Class Variables
    var realm: Realm
    var items: Results<OddJobItem>
    var sorts : Results<OddJobItem>!
    let themes: Results<ThemeItem>
    let scoreItem: Results<ScoreItem>
    var scoreVC = ScoreViewController()
    var notificationToken: NotificationToken?
    var delegate: HomeControllerDelegate?
    var searchBar = UISearchBar()
    let tableView = UITableView()
    
    // Initialize Realm
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items = realm.objects(OddJobItem.self).filter(Constants.taskDoneFilter, Constants.listTypes, [UserDefaults.standard.string(forKey: "Name") ?? ""])
        self.themes = realm.objects(ThemeItem.self).filter("Category contains[c] %@", "Theme")
        self.scoreItem = realm.objects(ScoreItem.self).filter("Category contains[c] %@", "Life")
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
        let sideBar = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.automatic), style: .plain, target: self, action: #selector(handleDismiss))
        addSearchBar(scoreCategory: Constants.archiveScoreCategory, searchBar: searchBar)
        addNavBar([sideBar], [logout], scoreCategory: Constants.archiveScoreCategory)
        tableView.addTableView(tableView, view)
        tableView.dataSource = self
        tableView.delegate = self
        addNotificationToken()
        setUpSearchBar(searchBar: searchBar)
        applyTheme(tableView,view)
        tableView.reloadData()
        hideKeyboardWhenTappedAround()

    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
    func addTableCell(_ tableView: UITableView, _ indexPath: IndexPath, _ cellFields:[String]) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cellSetup(cell, item, Constants.cellFields)
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return addTableCell(tableView, indexPath, Constants.cellFields)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        deleteOddJob(indexPath, realm: realm, items: items)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = UIContextualAction(style: .normal, title: Constants.undoneSwipe) { (action, view, completionHandler) in
            completionHandler(true)
            self.doneOddJob(indexPath, value: Constants.descreaseScore, realm: self.realm, items: self.items, themes: self.themes, scoreItem: self.scoreItem, tableView: self.tableView)
        }
        done.backgroundColor = Themes.current.undone
        let config = UISwipeActionsConfiguration(actions: [done])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

extension DoneViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("typing in search bar: term = \(searchText)")
        if searchText != "" {
            let predicate = NSPredicate(format:Constants.doneSearchFilter, searchText, searchText, Constants.listTypes,[UserDefaults.standard.string(forKey: "Name") ?? ""])
            self.items = realm.objects(OddJobItem.self).filter(predicate)
            tableView.reloadData()
        } else {
            self.items = realm.objects(OddJobItem.self).filter(Constants.taskDoneFilter, Constants.listTypes, [UserDefaults.standard.string(forKey: "Name") ?? ""])
            tableView.reloadData()
        }
        tableView.reloadData()
    }
}
