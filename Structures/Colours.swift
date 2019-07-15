//
//  Colours.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 11/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let navyTheme = UIColor().hexColor("3D405B")
    static let orangeTheme = UIColor().hexColor("E07A5F")
    static let greenTheme = UIColor().hexColor("31BC53")
    static let blueTheme = UIColor().hexColor("20A4F3")
    static let darkTheme = UIColor().hexColor("453823")
    func hexColor(_ hex : String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        if hexString.count != 6{
            return UIColor.black
        }
        var rgb : UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgb)
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat(rgb & 0x0000FF) / 255.0,
                                          alpha: 1.0)
    }
}


