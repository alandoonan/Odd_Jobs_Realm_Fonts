//
//  ItemsViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift
class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let realm: Realm
    let settings: Results<SettingItem>
    let tableView = UITableView()
    let personalVC = PersonalViewController()
    var notificationToken: NotificationToken?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.settings = realm.objects(SettingItem.self).filter("Category contains[c] %@", "Setting")
        super.init(nibName: nil, bundle: nil)
        addSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.backgroundColor = UIColor.navyTheme
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = self.view.frame
        notificationToken = settings.observe { [weak self] (changes) in
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = settings[indexPath.row]
        try! realm.write {
            item.IsDone = !item.IsDone
        }
        tableView.backgroundColor = UIColor().hexColor(item.hexColour)
        self.personalVC.tableView.backgroundColor =  UIColor().hexColor(item.hexColour)
        self.personalVC.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        let item = settings[indexPath.row]
        cell.textLabel?.text = item.name
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor().hexColor(item.hexColour)
        cell.accessoryType = item.IsDone ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let item = settings[indexPath.row]
        try! realm.write {
            realm.delete(item)
        }
    }
    
    fileprivate func addSettings() {
        if realm.objects(SettingItem.self).count != 0
        {
            print("Setting Item Exists")
        }
        else {
            print("Settings Item Doesn't Exists")
            print("Creating Setting Item")
            for colour in Constants.themeColours {
                let settingItem = SettingItem()
                settingItem.settingType = "Theme"
                settingItem.name = colour.key
                settingItem.hexColour = colour.value
                try! self.realm.write {
                    self.realm.add(settingItem)
                }
            }
        }
    }
}
