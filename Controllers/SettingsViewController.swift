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
    let scoreItem: Results<ScoreItem>
    let tableView = UITableView()
    let personalVC = PersonalViewController()
    var notificationToken: NotificationToken?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.settings = realm.objects(SettingItem.self).filter("Category contains[c] %@", "Setting")
        self.scoreItem = realm.objects(ScoreItem.self).filter("Category contains[c] %@", "Personal")
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
        navigationItem.title = "Settings"
        addSettings()
        tableView.backgroundColor = UIColor.navyTheme
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = self.view.frame
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.addSubview(tableView)
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
        print("Changing Table View Colour")
        tableView.backgroundColor = UIColor().hexColor(item.hexColour)
        //        print("Changing Personal Table View Colour")
        //        self.personalVC.tableView.backgroundColor =  UIColor().hexColor(item.hexColour)
        //        self.personalVC.tableView.reloadData()
        //        self.personalVC.viewDidLoad()
        //        print("Using Theme Struct")
        //        Colours.navyTheme()
        //        self.viewDidLoad()
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
        if settings.count <= Constants.themeColours.count
        {
            for colour in Constants.themeColours {
                let found = findObjectsByName(colour.key)
                if found .isEmpty {
                    for score in scoreItem {
                        if score.TotalScore > Int(colour.value[1])!
                        {
                            let settingItem = SettingItem()
                            settingItem.settingType = "Theme"
                            settingItem.name = colour.key
                            settingItem.hexColour = colour.value[0]
                            settingItem.UnlockLevel = Int(colour.value[1])!
                            try! self.realm.write {
                                self.realm.add(settingItem)
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func findObjectsByName(_ Name: String) -> Results<SettingItem>
    {
        let predicate = NSPredicate(format: "name = %@", Name)
        return realm.objects(SettingItem.self).filter(predicate)
    }
}
