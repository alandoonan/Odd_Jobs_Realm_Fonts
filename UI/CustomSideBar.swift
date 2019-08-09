//
//  CustomSideBar.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 09/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//
import UIKit

class CustomSideBar: SideMenuController {
    
    required init?(coder aDecoder: NSCoder) {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 300
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
        super.init(coder: aDecoder)
    }
}
