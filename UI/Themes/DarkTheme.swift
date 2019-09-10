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
    var background: UIColor = UIColor.darkTheme
    var tint: UIColor = UIColor.darkTheme
    var done: UIColor = UIColor.greenTheme
    var undone: UIColor = .gray
    var celltext: UIColor = UIColor.darkTheme
    var themecelltext: UIColor = UIColor.orangeTheme
    var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
