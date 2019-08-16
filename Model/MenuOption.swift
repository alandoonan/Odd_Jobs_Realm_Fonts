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
    case Score
    case Themes
    
    var description: String {
        switch self {
        case .Lists: return "Lists"
        case .Score: return "Score"
        case .Themes: return "Themes"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Lists: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        case .Score: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        case .Themes: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        }
    }
}

