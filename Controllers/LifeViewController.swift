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
class LifeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let realm: Realm
    let items: Results<OddJobItem>
    var holidayDictionary:[String:String] = [:]
    let tableView = UITableView()
    let loginVC = LoginViewController()
    var notificationToken: NotificationToken?
    let calendar = Calendar.current
    let date = Date()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHolidayData()
        tableView.backgroundColor = UIColor.clear
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(rightBarButtonDidClick))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidClick))
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchOddJobs))
        navigationItem.rightBarButtonItems = [logout,search]
        navigationItem.title = "Life Odd Jobs"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.addSubview(tableView)
        tableView.frame = self.view.frame
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
    
    @objc func rightBarButtonDidClick() {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        try! realm.write {
            item.IsDone = !item.IsDone
        }
    }
    
    @objc func searchOddJobs() {
        print("Search Button Pressed")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        let item = items[indexPath.row]
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
    
    @objc func addButtonDidClick() {
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
