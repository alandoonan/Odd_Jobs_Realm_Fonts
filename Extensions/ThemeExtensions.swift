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
        
        
//        Themes.current = BlueTheme()
//        applyTheme(tableView,view)
//        applyThemeView(view)
//        view.layoutIfNeeded()
        
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
