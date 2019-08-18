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
    let tableView = UITableView()
    var notificationToken: NotificationToken?
    var delegate: HomeControllerDelegate?
    var searchBar = UISearchBar()
    var scoreCategory = ["Personal","Life","Group"]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items = realm.objects(OddJobItem.self).filter("Category in %@", ["Personal","Life","Group"])
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
        applyTheme()
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
    
    private func setUpSearchBar() {
        searchBar.delegate = self
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
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutButtonPress))
        //let sort = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(selectSortField))
        //let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchOddJobs))
        let sideBar = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        addSearchBar(scoreCategory: scoreCategory)
        addNavBar([sideBar], [logout], scoreCategory: scoreCategory)
        tableView.addTableView(tableView, view)
        tableView.dataSource = self
        tableView.delegate = self
        addNotificationToken()
        addNotificationToken()
        setUpSearchBar()
        applyTheme()
        tableView.reloadData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }
    
    fileprivate func addSearchBar(scoreCategory: [String]) {
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false
        searchBar.placeholder = "Search " + scoreCategory.joined(separator:" ")
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
    
    fileprivate func isDoneUpdate(_ indexPath: IndexPath) {
        let oddJobitem = items[indexPath.row]
        try! realm.write {
            oddJobitem.IsDone = !oddJobitem.IsDone
        }
        if oddJobitem.IsDone == true {
            updateScore()
        }
    }
    
    @objc func updateScore() {
        print("Updating Scores")
        for update in Constants.listTypes {
            let scores = realm.objects(ScoreItem.self).filter("Category contains[c] %@", update)
            if let score = scores.first {
                if score.Score == score.LevelCap {
                    try! realm.write {
                        score.Score = 0
                        score.Level += 1
                        score.TotalScore += 1
                    }
                }
                else {
                    try! realm.write {
                        score.Score += 1
                        score.TotalScore += 1
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isDoneUpdate(indexPath)
    }
    
    fileprivate func addTableCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        let item = items[indexPath.row]
        cell.textLabel?.text = item.Name
        cell.tintColor = .white
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        if item.Category == "Personal" {
            cell.backgroundColor = UIColor.orangeTheme
        }
        if item.Category == "Life" {
            cell.backgroundColor = UIColor.greenTheme
        }
        if item.Category == "Group" {
            cell.backgroundColor = UIColor.blueTheme
        }
        cell.detailTextLabel?.text = ("Priority: " + item.Priority)
        cell.detailTextLabel?.text = ("Occurence: " + item.Occurrence)
        cell.accessoryType = item.IsDone ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return addTableCell(tableView, indexPath)
    }
    
    fileprivate func rssSelectionSort() {
        print("Sort Button Pressed")
        let sortFields: [String] = ["Name", "Priority", "Occurrence"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(dataSource: sortFields) { (cell, name, indexPath) in
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
    
    fileprivate func applyTheme() {
        view.backgroundColor = Themes.current.background
        tableView.backgroundColor = Themes.current.background
        navigationController?.navigationBar.backgroundColor = Themes.current.background
        let textAttributes = [NSAttributedString.Key.foregroundColor:Themes.current.accent]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let item = items[indexPath.row]
        try! realm.write {
            realm.delete(item)
        }
    }
}
