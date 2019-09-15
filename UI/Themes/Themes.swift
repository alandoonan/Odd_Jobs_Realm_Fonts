//
//  Themes.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 11/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

class Themes {

    static let mainFontName = "ArialRoundedMTBold"
//    static let accent = UIColor.orangeTheme
//    static let background = UIColor.navyTheme
//    static let tint = UIColor.greenTheme
    static var current: ThemeProtocol  = Dark()
    
    static func applyTheme() {
        // First persist the selected theme using NSUserDefaults.
        UserDefaults.standard.synchronize()
        
        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = Themes.current.background
        
        UINavigationBar.appearance().backgroundColor = Themes.current.background
        UITabBar.appearance().backgroundColor = Themes.current.background
        UIView.appearance().backgroundColor = Themes.current.background
    }
}
