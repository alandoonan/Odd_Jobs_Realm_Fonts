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
    let scoreVC = ScoreViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation bar appearance
        let navigationAppearance = UINavigationBar.appearance()
        navigationAppearance.tintColor = UIColor.orangeTheme
        navigationAppearance.barTintColor = UIColor.navyTheme
        navigationAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        // Tab bar appearance
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor.orangeTheme
        tabBarAppearance.barTintColor = UIColor.navyTheme
        
        // List Controllers
        let personalTab = UINavigationController(rootViewController: PersonalViewController())
        let groupTab = UINavigationController(rootViewController: GroupViewController())
        let lifeTab = UINavigationController(rootViewController: LifeViewController())
        let summaryTab = UINavigationController(rootViewController: SummaryViewController())
        let settingsTab = UINavigationController(rootViewController: SettingsViewController())
        let scoreTab = UINavigationController(rootViewController: ScoreViewController())
        self.view.backgroundColor = UIColor.navyTheme
        viewControllers = [groupTab,personalTab,lifeTab,summaryTab,settingsTab,scoreTab]

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Test")
    }
}
