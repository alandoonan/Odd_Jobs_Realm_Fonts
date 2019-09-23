//
//  HomeViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 09/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

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
    
    fileprivate func setupTabBarButton(tab: UINavigationController, image: UIImage, title: String) {
        tab.tabBarItem.image = image
        tab.title = title
    }
    
    fileprivate func setupView(_ groupTab: UINavigationController, _ personalTab: UINavigationController, _ lifeTab: UINavigationController, _ summaryTab: UINavigationController) {
        self.view.backgroundColor = Themes.current.background
        viewControllers = [summaryTab,personalTab,lifeTab,groupTab]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabBarButton(tab: personalTab, image:#imageLiteral(resourceName: "task").withRenderingMode(.automatic), title: "Personal")
        setupTabBarButton(tab: groupTab, image:#imageLiteral(resourceName: "users").withRenderingMode(.automatic), title: "Group")
        setupTabBarButton(tab: lifeTab, image:#imageLiteral(resourceName: "lifetask").withRenderingMode(.automatic), title: "Life")
        setupTabBarButton(tab: summaryTab, image:#imageLiteral(resourceName: "oddjobs").withRenderingMode(.automatic), title: "Summary")
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
