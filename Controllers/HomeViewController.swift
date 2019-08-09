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
        
        // Background
        view.backgroundColor = UIColor.navyTheme
        // List Controllers
        let personalTab = UINavigationController(rootViewController: PersonalViewController())
        let groupTab = UINavigationController(rootViewController: GroupViewController())
        let lifeTab = UINavigationController(rootViewController: LifeViewController())
        let summaryTab = UINavigationController(rootViewController: SummaryViewController())
        let settingsTab = UINavigationController(rootViewController: SettingsViewController())
        let scoreTab = UINavigationController(rootViewController: ScoreViewController())
        scoreTab.view.backgroundColor = UIColor.navyTheme
        self.view.backgroundColor = UIColor.navyTheme
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchOddJobs))
        navigationItem.leftBarButtonItems = [search]
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
