//
//  ThemeProtocol.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 11/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    var mainFontName: String { get }
    var accent: UIColor { get }
    var background: UIColor { get }
    var tint: UIColor { get }
    var preferredStatusBarStyle: UIStatusBarStyle { get }
    }
