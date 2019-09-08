//
//  LightTheme.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 11/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

class DarkTheme: ThemeProtocol {
    var mainFontName: String = ""
    var textColour: UIColor = UIColor.white
    var accent: UIColor = UIColor.orangeTheme
    var background: UIColor = .darkGray
    var tint: UIColor = .darkGray
    var done: UIColor = UIColor.greenTheme
    var undone: UIColor = .gray
    var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
