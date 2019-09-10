//
//  DarkTheme.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 11/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//
import UIKit

class PersonalTheme: ThemeProtocol {
    var mainFontName: String = ""
    var textColour: UIColor = UIColor.white
    var accent: UIColor = UIColor.orangeTheme
    var background: UIColor = UIColor.greenTheme
    var tint: UIColor = UIColor.greenTheme
    var done: UIColor = UIColor.orangeTheme
    var undone: UIColor = .gray
    var celltext: UIColor = UIColor.darkTheme
    var themecelltext: UIColor = UIColor.darkTheme

    var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
