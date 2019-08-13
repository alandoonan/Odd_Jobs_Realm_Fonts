//
//  MenuOption.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 13/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case Personal
    case Group
    case Life
    case Summary
    case Settings
    case Score
    
    var description: String {
        switch self {
        case .Personal: return "Personal"
        case .Group: return "Group"
        case .Life: return "Life"
        case .Summary: return "Summary"
        case .Settings: return "Settings"
        case .Score: return "Score"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Personal: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        case .Group: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        case .Life: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        case .Summary: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        case .Settings: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        case .Score: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        }
    }
}

