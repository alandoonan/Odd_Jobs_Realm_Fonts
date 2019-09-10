//
//  MenuOption.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 13/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case Lists
    case Archive
    case Score
    case Themes
    case Locations
    case Users
    case CreateLifeTask
    case CreateTask
    case Logout
    
    var description: String {
        switch self {
        case .Lists: return "Lists"
        case .Archive: return "Archive"
        case .Score: return "Score"
        case .Themes: return "Themes"
        case .Locations: return "Locations"
        case .Users: return "Users"
        case .CreateLifeTask: return "Create Life Task"
        case .CreateTask: return "Create Task"
        case .Logout: return "Log Out"

        }
    }
    
    var image: UIImage {
        switch self {
        case .Lists: return UIImage(named: "oddjobs.png") ?? UIImage()
        case .Archive: return UIImage(named: "archive.png") ?? UIImage()
        case .Score: return UIImage(named: "trophy_sidebar.png") ?? UIImage()
        case .Themes: return UIImage(named: "themes.png") ?? UIImage()
        case .Locations: return UIImage(named: "location.png") ?? UIImage()
        case .Users: return UIImage(named: "users.png") ?? UIImage()
        case .CreateLifeTask: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        case .CreateTask: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        case .Logout: return UIImage(named: "logout.png") ?? UIImage()

        }
    }
}

