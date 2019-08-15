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
class PersonalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate
{
    func updateSearchResults(for searchController: UISearchController) {
        print("Search Results Updating")
    }
    
    var realm: Realm
    var items: Results<OddJobItem>
    var sorts : Results<OddJobItem>!
    var scoreVC = ScoreViewController()
    let tableView = UITableView()
    var notificationToken: NotificationToken?
    var scoreCateogry = "Personal"
    var delegate: HomeControllerDelegate?
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    var animalArray = [OddJobItem]()
    var currentAnimalArray = [OddJobItem]() //update table
    var searchBar = UISearchBar()
    var products: Results<OddJobItem>?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items = realm.objects(OddJobItem.self).filter("Category contains[c] %@", "Personal")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    fileprivate func addTableView() {
        tableView.backgroundColor = Themes.current.background
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = self.view.frame
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.addSubview(tableView)
    }
    
    fileprivate func addNavBar(_ sideBar: UIBarButtonItem,_ add: UIBarButtonItem, _ search: UIBarButtonItem, _ logout: UIBarButtonItem, _ sort: UIBarButtonItem) {
        navigationItem.leftBarButtonItems = [sideBar, add] //, add ,search
        navigationItem.rightBarButtonItems = [logout] //,sort
        navigationItem.title = "Personal Odd Jobs"
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
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false // you can show/hide this dependant on your layout
        searchBar.placeholder = "Search Animal by Name"
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(rightBarButtonDidClick))
        let sort = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(selectSortField))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidClick))
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchOddJobs))
        let sideBar = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        addNavBar(sideBar, add, search, logout, sort)
        addTableView()
        addNotificationToken()
        setUpSearchBar()
        tableView.reloadData()

    }
    
    @objc func rightBarButtonDidClick() {
        let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "Yes, Logout", style: .destructive, handler: {
            alert -> Void in
            SyncUser.current?.logOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oddJobitem = items[indexPath.row]
        try! realm.write {
            oddJobitem.IsDone = !oddJobitem.IsDone
        }
        if oddJobitem.IsDone == true {
            scoreVC.updateScore()
            scoreVC.autoRefreshScores(scoreCategory: scoreCateogry)
        }
    }
    
    fileprivate func addTableCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        let item = items[indexPath.row]
        cell.textLabel?.text = item.Name
        cell.tintColor = .white
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.backgroundColor = UIColor.orangeTheme
        cell.detailTextLabel?.text = ("Priority: " + item.Priority)
        cell.detailTextLabel?.text = ("Occurence: " + item.Occurrence)
        cell.accessoryType = item.IsDone ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return addTableCell(tableView, indexPath)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(self.items)
        print("typing in search bar: term = \(searchText)")
        if searchText != "" {
            let predicate = NSPredicate(format:"Name CONTAINS[c] %@", searchText)
            products = realm.objects(OddJobItem.self).filter(predicate)
            print(products!)
        } else {
            print("Sorting")
        }
        tableView.reloadData()
//        currentAnimalArray = self.items { OddJobItem -> Bool in
//            switch searchBar.selectedScopeButtonIndex {
//            case 0:
//                print("Search bar pressed 0 1")
//
//                print(searchText)
//
//                if searchText.isEmpty { return true }
//                return OddJobItem.Name.lowercased().contains(searchText.lowercased())
//            case 1:
//                print("Search bar pressed 1 1")
//                print(searchText)
//
//                if searchText.isEmpty { return OddJobItem.Category == "Personal" }
//                return OddJobItem.Name.lowercased().contains(searchText.lowercased()) &&
//                    OddJobItem.Category == "Personal"
//            case 2:
//                print("Search bar pressed 2 1")
//                print(searchText)
//
//                if searchText.isEmpty { return OddJobItem.Category == "Group" }
//                return OddJobItem.Name.lowercased().contains(searchText.lowercased()) &&
//                    OddJobItem.Category == "Group"
//            default:
//                return false
//            }
//        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {

        case 0:
            print("Search bar pressed 2 0")
            currentAnimalArray = animalArray
        case 1:
            print("Search bar pressed 2 1")
            currentAnimalArray = items.filter({ animal -> Bool in
                animal.Category == "Personal"
            })
        case 2:
            print("Search bar pressed 2 2")

            currentAnimalArray = items.filter({ animal -> Bool in
                animal.Category == "Group"
            })
        default:
            break
        }
        tableView.reloadData()
    }
    
    @objc func searchOddJobs() {
        print("Search Button Pressed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MapTasksViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
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
    fileprivate func personalAddAlert() {
        let alertController = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let oddJobName = alertController.textFields![0] as UITextField
            let oddJobPriority = alertController.textFields![1] as UITextField
            let oddJobOccurrence = alertController.textFields![2] as UITextField
            let oddJobLocation = alertController.textFields![3] as UITextField
            let item = OddJobItem()
            item.Name = oddJobName.text ?? ""
            item.Priority = oddJobPriority.text ?? ""
            item.Occurrence = oddJobOccurrence.text ?? ""
            item.Location = oddJobLocation.text ?? ""
            item.Longitude = -7.386739
            item.Latitude = 53.322185
            item.Category = "Personal"
            try! self.realm.write {
                self.realm.add(item)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        for field in Constants.personalAlertFields {
            alertController.addTextField(configurationHandler: {(oddJobName : UITextField!) -> Void in
                oddJobName.placeholder = field
            })
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func addButtonDidClick() {
        personalAddAlert()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let item = items[indexPath.row]
        try! realm.write {
            realm.delete(item)
        }
    }
}
