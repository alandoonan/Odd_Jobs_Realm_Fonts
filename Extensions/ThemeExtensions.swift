//
//  ThemeExtensions.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 14/09/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

extension UIViewController {
    
    func applyTheme(_ tableView: UITableView, _ view: UIView) {
        let attributes = [NSAttributedString.Key.foregroundColor: Themes.current.accent]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
        let textAttributes = [NSAttributedString.Key.foregroundColor:Themes.current.accent]
        view.backgroundColor = Themes.current.background
        tableView.backgroundColor = Themes.current.background
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = .none
        tableView.separatorColor = Themes.current.background
        UILabel.appearance().tintColor = Themes.current.accent
        navigationController?.navigationBar.barTintColor = Themes.current.background
        navigationController?.navigationBar.tintColor = Themes.current.accent
        navigationController?.navigationBar.backgroundColor = Themes.current.background
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        tabBarController?.tabBar.backgroundColor = Themes.current.background
        tabBarController?.tabBar.barTintColor = Themes.current.background
        tabBarController?.tabBar.tintColor = Themes.current.accent
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 20)!, NSAttributedString.Key.foregroundColor : Themes.current.accent]
    }
    
    func applyThemeView(_ view: UIView) {
        let attributes = [NSAttributedString.Key.foregroundColor: Themes.current.accent]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
        let textAttributes = [NSAttributedString.Key.foregroundColor:Themes.current.accent]
        view.backgroundColor = Themes.current.background
        UILabel.appearance().tintColor = Themes.current.accent
        navigationController?.navigationBar.backgroundColor = Themes.current.background
        navigationController?.navigationBar.barTintColor = Themes.current.background
        navigationController?.navigationBar.tintColor = Themes.current.accent
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        tabBarController?.tabBar.backgroundColor = Themes.current.background
        tabBarController?.tabBar.barTintColor = Themes.current.background
        tabBarController?.tabBar.tintColor = Themes.current.accent
        UINavigationBar.appearance().barTintColor = Themes.current.background
        UINavigationBar.appearance().tintColor = Themes.current.accent
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 20)!, NSAttributedString.Key.foregroundColor : Themes.current.accent]
    }
    
    func addThemes(realm: Realm, themes: Results<ThemeItem>, scoreItem: Results<ScoreItem>, tableView:UITableView) {
        print("Checking Themes")
        let unlocked = checkThemeUnlocked(realm: realm, themes: themes, scoreItem: scoreItem, tableView: tableView)
        print(unlocked)
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
                            themeItem.CellColour = colour.value[4]
                            themeItem.User = UserDefaults.standard.string(forKey: "Name") ?? ""
                            try! realm.write {
                                realm.add(themeItem)
                            }
                        }
                    }
                }
                else {
                    print("No new themes to unlock")
                }
            }
        }
    }
    
    func themeUnlockedAlert(theme: String, tableView: UITableView) {
        let alert = UIAlertController(title: (theme + " Theme Unlocked"), message: "Do you want to apply it?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            //run your function here
            if theme == "Blue" {
                self.applyBlueTheme(tableView)
            }
            if theme == "Dark" {
                self.applyDarkTheme(tableView)
            }
            if theme == "Hulk" {
                self.applyHulkTheme(tableView)
            }
            if theme == "Orange" {
                self.applyOrangeTheme(tableView)
            }
            if theme == "Batman" {
                self.applyBatmanTheme(tableView)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func checkThemeUnlocked(realm: Realm, themes: Results<ThemeItem>, scoreItem: Results<ScoreItem>, tableView: UITableView) -> Bool{
        var unlocked = false
        for item in Constants.themeColours {
            let themeSearch = findColourByName(item.key, realm: realm)
            if (themeSearch.first?.name != nil && themeSearch.first?.userAlerted == false && Int(item.value[1])! >= themeSearch.first!.UnlockLevel) {
                print("Theme Unlocked: " + themeSearch.first!.name)
                try! realm.write {
                    themeSearch.first?.userAlerted = true
                    themeUnlockedAlert(theme: item.key, tableView: tableView)
                    print(item.key)
                    
                    
                }
                unlocked = true
            }
        }
        return unlocked
    }
    
    func applyTaskTheme(tableView: UITableView, selectTaskButton: UIButton, selectCategoryButton: UIButton, selectWhenButton: UIButton, userLabel: UILabel) {
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        selectTaskButton.backgroundColor = Themes.current.accent
        selectCategoryButton.backgroundColor = Themes.current.accent
        selectWhenButton.backgroundColor = Themes.current.accent
        selectTaskButton.titleLabel?.textColor = Themes.current.background
        selectTaskButton.setTitleColor(Themes.current.background, for: .normal)
        selectCategoryButton.setTitleColor(Themes.current.background, for: .normal)
        selectWhenButton.setTitleColor(Themes.current.background, for: .normal)
        userLabel.text = UserDefaults.standard.string(forKey: "Name") ?? ""
        userLabel.textColor = Themes.current.accent
        let navigationAppearance = UINavigationBar.appearance()
        navigationAppearance.tintColor = Themes.current.accent
        navigationAppearance.barTintColor = Themes.current.background
        navigationAppearance.backgroundColor = Themes.current.background
        navigationAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 20)!, NSAttributedString.Key.foregroundColor : Themes.current.accent]

    }
    
    func applyBlueTheme(_ tableView: UITableView) {
        print(String(describing: type(of: Blue())))
        Themes.current = Blue()
        applyTheme(tableView,view)
        applyThemeView(view)
        view.layoutIfNeeded()
    }
    
    func applyDarkTheme(_ tableView: UITableView) {
        print(String(describing: type(of: Dark())))
        Themes.current = Dark()
        applyTheme(tableView,view)
        applyThemeView(view)
        view.layoutIfNeeded()
    }
    
    func applyHulkTheme(_ tableView: UITableView) {
        print(String(describing: type(of: Hulk())))
        Themes.current = Hulk()
        applyTheme(tableView,view)
        applyThemeView(view)
        view.layoutIfNeeded()
    }
    
    func applyOrangeTheme(_ tableView: UITableView) {
        print(String(describing: type(of: Orange())))
        Themes.current = Orange()
        applyTheme(tableView,view)
        applyThemeView(view)
        view.layoutIfNeeded()
    }
    
    func applyBatmanTheme(_ tableView: UITableView) {
        print(String(describing: type(of: Batman())))
        Themes.current = Batman()
        applyTheme(tableView,view)
        applyThemeView(view)
        view.layoutIfNeeded()
    }
}
