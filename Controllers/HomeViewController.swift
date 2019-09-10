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
    let personalTab = UINavigationController(rootViewController: PersonalViewController())
    let groupTab = UINavigationController(rootViewController: GroupViewController())
    let lifeTab = UINavigationController(rootViewController: LifeViewController())
    let summaryTab = UINavigationController(rootViewController: SummaryViewController())
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }
    
    fileprivate func setupTabBar() {
        // Tab bar appearance
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = Themes.current.accent
        tabBarAppearance.barTintColor = Themes.current.background
    }
    
    fileprivate func setupTabBarButton(tab: UINavigationController, image: String, title: String) {
        tab.tabBarItem.image = UIImage(named: image)
        tab.title = title
    }
    
    fileprivate func setupView(_ groupTab: UINavigationController, _ personalTab: UINavigationController, _ lifeTab: UINavigationController, _ summaryTab: UINavigationController) {
        self.view.backgroundColor = Themes.current.background
        viewControllers = [groupTab,personalTab,lifeTab,summaryTab]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTabBar()
        setupTabBarButton(tab: personalTab, image: "P.png", title: "Personal")
        setupTabBarButton(tab: groupTab, image: "G.png", title: "Group")
        setupTabBarButton(tab: lifeTab, image: "L.png", title: "Life")
        setupTabBarButton(tab: summaryTab, image: "summary.png", title: "Summary")
        setupView(groupTab, personalTab, lifeTab, summaryTab)
        applyThemeView(view)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Tab Bar Touch Test")
        if tabBar.selectedItem?.title == "Score" {
            print("Score")
        }
    }
}
