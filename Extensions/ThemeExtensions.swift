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
    
    func addThemess(realm: Realm, themes: Results<ThemeItem>, scoreItem: Results<ScoreItem>) {
        print("Checking Themes")
        let unlocked = checkThemeUnlocked(realm: realm, themes: themes, scoreItem: scoreItem)
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
    
    func addThemes(realm: Realm, themes: Results<ThemeItem>, scoreItem: Results<ScoreItem>) {
        print("Checking Themes")
        let unlocked = checkThemeUnlocked(realm: realm, themes: themes, scoreItem: scoreItem)
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
    
    func themeUnlockedAlert() {
        let alert = UIAlertController(title: "New Theme Unlocked", message: "Do you want to apply it?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func checkThemeUnlocked(realm: Realm, themes: Results<ThemeItem>, scoreItem: Results<ScoreItem>) -> Bool{
        var unlocked = false
        for item in Constants.themeColours {
            let themeSearch = findColourByName(item.key, realm: realm)
            if (themeSearch.first?.name != nil && themeSearch.first?.userAlerted == false && Int(item.value[1])! >= themeSearch.first!.UnlockLevel) {
                print("Theme Unlocked: " + themeSearch.first!.name)
                try! realm.write {
                    themeSearch.first?.userAlerted = true
                    themeUnlockedAlert()
                }
                unlocked = true
            }
        }
        return unlocked
    }
}
