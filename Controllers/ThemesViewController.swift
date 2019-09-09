//
//  ItemsViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift
class ThemesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let realm: Realm
    let themes: Results<ThemeItem>
    let scoreItem: Results<ScoreItem>
    let tableView = UITableView()
    let personalVC = PersonalViewController()
    var notificationToken: NotificationToken?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.themes = realm.objects(ThemeItem.self).filter("Category contains[c] %@", "Theme")
        self.scoreItem = realm.objects(ScoreItem.self).filter("Category contains[c] %@", "Personal")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    fileprivate func addNotificationToken() {
        notificationToken = themes.observe { [weak self] (changes) in
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
        navigationItem.title = "Themes"
        addThemes()
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutButtonPress))
        let sideBar = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        addNavBar([sideBar], [logout], scoreCategory: ["Themes"])
        applyTheme(tableView,view)
        tableView.addTableView(tableView, view)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        addNotificationToken()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        applyTheme(tableView,view)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func addTableCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let item = themes[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor().hexColor(item.hexColour)
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        cell.tintColor = Themes.current.accent
        cell.textLabel?.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return addTableCell(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at:indexPath)!.accessoryType = .checkmark
        for cellPath in tableView.indexPathsForVisibleRows!{
            if cellPath == indexPath{
                continue
            }
            tableView.cellForRow(at: cellPath)!.accessoryType = .none
        }
        let cell = tableView.cellForRow(at: indexPath)?.textLabel?.text
        if cell == "Blue" {
            Themes.current = BlueTheme()
        }
        if cell == "Dark" {
            Themes.current = DarkTheme()
        }
        if cell == "The Hulk" {
            Themes.current = HulkTheme()
        }
        if cell == "Orange" {
            Themes.current = OrangeTheme()
        }
        if cell == "Batman" {
            Themes.current = BatmanTheme()
        }
        else {
            print("Theme not found")
        }
    }

    fileprivate func addThemes() {
        if themes.count <= Constants.themeColours.count
        {
            for colour in Constants.themeColours {
                let found = findColourByName(colour.key, realm: realm)
                if found .isEmpty {
                    for score in scoreItem {
                        if score.TotalScore > Int(colour.value[1])!
                        {
                            let themeItem = ThemeItem()
                            themeItem.Category = "Theme"
                            themeItem.name = colour.key
                            themeItem.hexColour = colour.value[0]
                            themeItem.UnlockLevel = Int(colour.value[1])!
                            themeItem.tag = Int(colour.value[2])!
                            try! self.realm.write {
                                self.realm.add(themeItem)
                            }
                        }
                    }
                }
            }
        }
    }
}


