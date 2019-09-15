//
//  ItemsViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
class LifeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate
{
    let realm: Realm
    var items: Results<OddJobItem>
    let loginVC = LoginViewController()
    var notificationToken: NotificationToken?
    var holidayDictionary:[String:String] = [:]
    let tableView = UITableView()
    let calendar = Calendar.current
    let date = Date()
    var searchBar = UISearchBar()
    
    // MARK: Initialize & View Did Load Functions
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items =  realm.objects(OddJobItem.self).filter(Constants.taskFilter, Constants.lifeScoreCategory)
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
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutButtonPress))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskPassThrough))
        let sideBar = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.automatic), style: .plain, target: self, action: #selector(handleDismiss))
        searchBar.keyboardAppearance = .dark
        getHolidayData()
        addSearchBar(scoreCategory: Constants.lifeScoreCategory, searchBar: searchBar)
        addNavBar([sideBar, add], [logout], scoreCategory: Constants.lifeScoreCategory)
        tableView.addTableView(tableView, view)
        tableView.dataSource = self
        tableView.delegate = self
        addNotificationToken()
        setUpSearchBar(searchBar: searchBar)
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
    func addNotificationToken() {
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
    
    // MARK: Search Bar Functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("typing in search bar: term = \(searchText)")
        if searchText != "" {
            let predicate = NSPredicate(format:Constants.searchFilter, searchText, searchText, Constants.lifeScoreCategory)
            self.items = realm.objects(OddJobItem.self).filter(predicate)
            self.tableView.reloadData()
        } else {
            self.items = realm.objects(OddJobItem.self).filter(Constants.taskFilter, Constants.lifeScoreCategory)
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
    }
    
    @objc func addTaskPassThrough() {
        showStoryBoardView(storyBoardID: "LifeTaskViewController")
    }
    
    //MARK: Holiday API Functions
    func getHolidayData () {
        print("Getting Holiday Data")
        let locale = Locale.current.regionCode!
        print(locale)
        let params = [
            "key": HolidayItem.key,
            "country": "IE",
            "year" : HolidayItem.year,
            "upcoming" : HolidayItem.upcoming,
            "pretty": HolidayItem.pretty,
            "public": false,
            "month" : calendar.component(.month, from: date)
            ] as [String : Any]
        Alamofire.request(HolidayItem.url!, parameters: params).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                for holiday in json["holidays"].arrayValue
                {
                    if  let name = holiday["name"].string,
                        let date = holiday["date"].string {
                        self.holidayDictionary[name] = date
                    }
                }
                self.addHolidayData()
            }
        }
    }
    func addHolidayData () {
        print("Adding Holiday Data to Life Lists")
        for holiday in holidayDictionary.sorted(by: { $0.1 < $1.1 }) {
            print(holiday)
            let found = findOddJobItemByName(holiday.key, realm: realm)
            if found .isEmpty{
                let item = OddJobItem()
                item.Name = holiday.key
                item.Priority = "High"
                item.Occurrence = "Yearly"
                item.Category = "Life"
                item.DueDate = holiday.value
                try! self.realm.write {
                    self.realm.add(item)
                }
            }
            else {
                print("Found. Do Nothing")
            }
        }
    }
    
    // MARK: TableView Functions
    // MARK: This is in all classes (REFACTOR)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return addTableCell(tableView, indexPath, Constants.cellFields, items: items)
    }
}
