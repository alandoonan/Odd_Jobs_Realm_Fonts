//
//  Colours.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 11/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

struct Colours {
    
    static var tableViewColor:UIColor?
    static var backgroundColor:UIColor?
    static var buttonTextColor:UIColor?
    static var buttonBackgroundColor:UIColor?
    static var navigationBackgroundColor:UIColor?
    
    static public func blueTheme() {
        self.tableViewColor = UIColor.blueTheme
        self.backgroundColor = UIColor.blueTheme
        self.buttonTextColor = UIColor.white
        updateDisplay()
    }
    
    static public func navyTheme() {
        self.backgroundColor = UIColor.navyTheme
        self.tableViewColor = UIColor.navyTheme
        self.buttonTextColor = UIColor.white
        updateDisplay()
    }
    
    static public func updateDisplay() {
        let proxyButton = UIButton.appearance()
        proxyButton.setTitleColor(Colours.buttonTextColor, for: .normal)
        proxyButton.backgroundColor = Colours.buttonBackgroundColor
        let proxyView = UIView.appearance()
        proxyView.backgroundColor = backgroundColor
        let proxyNav = UINavigationBar.appearance()
        proxyNav.backgroundColor = Colours.backgroundColor
        proxyNav.barTintColor = Colours.backgroundColor
        let proxyTab = UITabBar.appearance()
        proxyTab.barTintColor = Colours.backgroundColor
        let proxyNavCont = UINavigationController()
        proxyNavCont.navigationBar.isTranslucent = true
    }
}

extension UIColor {
    static let navyTheme = UIColor().hexColor("3D405B")
    static let orangeTheme = UIColor().hexColor("E07A5F")
    static let greenTheme = UIColor().hexColor("31BC53")
    static let blueTheme = UIColor().hexColor("20A4F3")
    static let darkTheme = UIColor().hexColor("282b35")
    static let purpleTheme = UIColor().hexColor("34314C")
    static let hulkTheme = UIColor().hexColor("9bc063")
    static let batmanTheme = UIColor().hexColor("FDFF00")
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
    
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
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}




