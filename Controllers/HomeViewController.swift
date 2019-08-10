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
        personalTab.tabBarItem.image = UIImage(named: "P.png")
        personalTab.title = "Personal"
        let groupTab = UINavigationController(rootViewController: GroupViewController())
        groupTab.tabBarItem.image = UIImage(named: "G.png")
        groupTab.title = "Group"
        let lifeTab = UINavigationController(rootViewController: LifeViewController())
        lifeTab.tabBarItem.image = UIImage(named: "L.png")
        lifeTab.title = "Life"
        let summaryTab = UINavigationController(rootViewController: SummaryViewController())
        summaryTab.tabBarItem.image = UIImage(named: "summary.png")
        summaryTab.title = "Summary"
        let settingsTab = UINavigationController(rootViewController: SettingsViewController())
        settingsTab.tabBarItem.image = UIImage(named: "settings.png")
        settingsTab.title = "Settings"
        let scoreTab = UINavigationController(rootViewController: ScoreViewController())
        scoreTab.tabBarItem.image = UIImage(named: "goal.png")
        scoreTab.title = "Score"
        
        self.view.backgroundColor = UIColor.navyTheme
        viewControllers = [groupTab,personalTab,lifeTab,summaryTab,settingsTab,scoreTab]
    }
    
    @objc func searchOddJobs () {
        print("Search Odd Jobs")
    
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Tab Bar Touch Test")
    }
}
//extension HomeViewController: UITabBarControllerDelegate  {
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
//        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
//            return false // Make sure you want this as false
//        }
//
//        if fromView != toView {
//            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
//        }
//
//        return true
//    }
//}
