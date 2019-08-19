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
    var holidayDictionary:[String:String] = [:]
    let tableView = UITableView()
    let loginVC = LoginViewController()
    var notificationToken: NotificationToken?
    let calendar = Calendar.current
    let date = Date()
    var searchBar = UISearchBar()
    var scoreCategory = ["Life"]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items =  realm.objects(OddJobItem.self).filter("Category contains[c] %@", "Life")
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
    
    fileprivate func         addNotificationToken() {
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
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidClick))
        let sideBar = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        getHolidayData()
        addSearchBar(scoreCategory: scoreCategory, searchBar: searchBar)
        addNavBar([sideBar, add], [logout], scoreCategory: scoreCategory)
        tableView.addTableView(tableView, view)
        tableView.dataSource = self
        tableView.delegate = self
        addNotificationToken()
        addNotificationToken()
        setUpSearchBar(searchBar: searchBar)
        applyTheme(tableView,view)
        tableView.reloadData()
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
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
    
    @objc func searchOddJobs() {
        print("Search Button Pressed")
    }
    
    fileprivate func addTableCell(_ tableView: UITableView, _ item: OddJobItem) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.textLabel?.text = item.Name
        cell.backgroundColor = UIColor.greenTheme
        cell.tintColor = .white
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.text = ("Priority: " + item.Priority)
        cell.detailTextLabel?.text = ("Date: " + String(item.HolidayDate))
        cell.accessoryType = item.IsDone ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        return addTableCell(tableView, item)
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
            item.Category = "Life"
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
    
    func addHolidayData () {
        /*
         Create life tasks based on holiday data pulled from
         Holiday API. If data already exists in users list ensure
         it is not duplicated
         */
        print("Adding Holiday Data to Life Lists")
        for holiday in holidayDictionary.sorted(by: { $0.1 < $1.1 }) {
            print(holiday)
            let found = findObjectsByName(holiday.key)
            if found .isEmpty{
                let item = OddJobItem()
                item.Name = holiday.key
                item.Priority = "High"
                item.Occurrence = "Yearly"
                item.Category = "Life"
                item.HolidayDate = holiday.value
                try! self.realm.write {
                    self.realm.add(item)
                }
            }
            else {
                print("Found. Do Nothing")
            }
        }
    }
    
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
    
    public func findObjectsByName(_ Name: String) -> Results<OddJobItem>
    {
        let predicate = NSPredicate(format: "Name = %@", Name)
        return realm.objects(OddJobItem.self).filter(predicate)
    }
}
