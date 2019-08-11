//
//  AppSettings.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 10/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import Foundation

class ThemeManager {
    
    static let sharedThemeManager = ThemeManager()
    
    func toggleTheme() {
        let def = UserDefaults.standard
        def.set(!isNightMode(), forKey: "Theme")
    }
    
    func isNightMode() -> Bool {
        let def = UserDefaults.standard
        return def.bool(forKey: "Theme")
    }
}
