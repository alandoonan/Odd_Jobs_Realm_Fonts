//
//  BatmanTheme.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 27/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

class Batman: ThemeProtocol {
    var mainFontName: String = ""
    var textColour: UIColor = UIColor.yellow
    var accent: UIColor = UIColor.yellow
    var background: UIColor = UIColor.black
    var tint: UIColor = UIColor.yellow
    var done: UIColor = UIColor.purpleTheme
    var undone: UIColor = .gray
    var celltext: UIColor = UIColor.darkTheme
    var themecelltext: UIColor = UIColor.black

    var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
