//
//  ItemsViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift
import RSSelectionMenu
class PersonalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var realm: Realm
    var items: Results<OddJobItem>
    var sorts : Results<OddJobItem>!
    var scoreVC = ScoreViewController()
    let tableView = UITableView()
    var notificationToken: NotificationToken?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(rightBarButtonDidClick))
        let sort = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(selectSortField))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidClick))
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchOddJobs))
        navigationItem.leftBarButtonItems = [add,search]
        navigationItem.rightBarButtonItems = [logout,sort]
        title = "Personal Odd Jobs"
        tableView.backgroundColor = UIColor.navyTheme
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = self.view.frame
        view.addSubview(tableView)
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
        let oddJobitem = items[indexPath.row]
        try! realm.write {
            oddJobitem.IsDone = !oddJobitem.IsDone
        }
        //SharedFunctions.removeTask(oddJobitem)
        if oddJobitem.IsDone == true {
            scoreVC.updateScore()
            scoreVC.increaseLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        return cell
    }
    
    @objc func searchOddJobs() {
        print("Search Button Pressed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MapTasksViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func selectSortField() {
        print("Sort Button Pressed")
        let sortFields: [String] = ["Name", "Priority", "Occurrence"]
        var selectedNames: [String] = []
        let menu = RSSelectionMenu(dataSource: sortFields) { (cell, name, indexPath) in
            cell.textLabel?.text = name
            cell.textLabel?.textColor = .white
            cell.backgroundColor = UIColor.navyTheme
        }
        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
            selectedNames = selectedItems
            self.sortOddJobs(sort: String(selectedItems[0]))
        }
        menu.show(style: .push, from: self)
    }
    
    @objc func sortOddJobs(sort:String) {
        self.items = self.items.sorted(byKeyPath: sort, ascending: true)
        //self.items = realm.objects(OddJobItem.self).sorted(byKeyPath: sort, ascending: true)
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
    @objc func addButtonDidClick() {
        
        //Alert
        let alertController = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let oddJobName = alertController.textFields![0] as UITextField
            let oddJobPriority = alertController.textFields![1] as UITextField
            let oddJobOccurrence = alertController.textFields![2] as UITextField
            //        let oddJobLongitude = alertController.textFields![4] as UITextField
            //        let oddJobLatitude = alertController.textFields![5] as UITextField
            
            //Realm
            let item = OddJobItem()
            item.Name = oddJobName.text ?? ""
            item.Priority = oddJobPriority.text ?? ""
            item.Occurrence = oddJobOccurrence.text ?? ""
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let item = items[indexPath.row]
        try! realm.write {
            realm.delete(item)
        }
    }
}
