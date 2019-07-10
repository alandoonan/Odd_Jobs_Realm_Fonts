//
//  HomeViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 09/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import Foundation
class HomeViewController: UITabBarController {
    override func viewDidLoad() {
        
        let personalTab = UINavigationController(rootViewController: PersonalViewController())
        let groupTab = UINavigationController(rootViewController: GroupViewController())
        let lifeTab = UINavigationController(rootViewController: LifeViewController())
        let settingsTab = UINavigationController(rootViewController: SettingsViewController())
        
        settingsTab.tabBarItem.title = "Settings"
        
        viewControllers = [groupTab,personalTab, lifeTab,settingsTab]
        super.viewDidLoad()
    }
}
