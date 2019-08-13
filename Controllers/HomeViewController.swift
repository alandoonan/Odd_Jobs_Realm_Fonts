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
    let personalTab = UINavigationController(rootViewController: PersonalViewController())
    let groupTab = UINavigationController(rootViewController: GroupViewController())
    let lifeTab = UINavigationController(rootViewController: LifeViewController())
    let summaryTab = UINavigationController(rootViewController: SummaryViewController())
    let settingsTab = UINavigationController(rootViewController: SettingsViewController())
    let scoreTab = UINavigationController(rootViewController: ScoreViewController())
    
    fileprivate func setupNavBar() {
        // Navigation bar appearance
        let navigationAppearance = UINavigationBar.appearance()
        navigationAppearance.tintColor = UIColor.orangeTheme
        navigationAppearance.barTintColor = UIColor.navyTheme
        navigationAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    fileprivate func setupTabBar() {
        // Tab bar appearance
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor.orangeTheme
        tabBarAppearance.barTintColor = UIColor.navyTheme
    }
    
    fileprivate func setupPersonalTab(_ personalTab: UINavigationController) {
        personalTab.tabBarItem.image = UIImage(named: "P.png")
        personalTab.title = "Personal"
    }
    
    fileprivate func setupGroupTab(_ groupTab: UINavigationController) {
        groupTab.tabBarItem.image = UIImage(named: "G.png")
        groupTab.title = "Group"
    }
    
    fileprivate func setupLifeTab(_ lifeTab: UINavigationController) {
        lifeTab.tabBarItem.image = UIImage(named: "L.png")
        lifeTab.title = "Life"
    }
    
    fileprivate func setupSummaryTab(_ summaryTab: UINavigationController) {
        summaryTab.tabBarItem.image = UIImage(named: "summary.png")
        summaryTab.title = "Summary"
    }
    
    fileprivate func setupSettingsTab(_ settingsTab: UINavigationController) {
        settingsTab.tabBarItem.image = UIImage(named: "settings.png")
        settingsTab.title = "Settings"
    }
    
    fileprivate func setupScoreTab(_ scoreTab: UINavigationController) {
        scoreTab.tabBarItem.image = UIImage(named: "goal.png")
        scoreTab.title = "Score"
    }
    
    fileprivate func setupView(_ groupTab: UINavigationController, _ personalTab: UINavigationController, _ lifeTab: UINavigationController, _ summaryTab: UINavigationController, _ settingsTab: UINavigationController, _ scoreTab: UINavigationController) {
        self.view.backgroundColor = UIColor.navyTheme
        viewControllers = [groupTab,personalTab,lifeTab,summaryTab,settingsTab,scoreTab]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTabBar()
        setupPersonalTab(personalTab)
        setupGroupTab(groupTab)
        setupLifeTab(lifeTab)
        setupSummaryTab(summaryTab)
        setupSettingsTab(settingsTab)
        setupScoreTab(scoreTab)
        setupView(groupTab, personalTab, lifeTab, summaryTab, settingsTab, scoreTab)
    }
    
    @objc func searchOddJobs () {
        print("Search Odd Jobs")
    
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Tab Bar Touch Test")
        if tabBar.selectedItem?.title == "Score" {
            print("Score")
            scoreVC.viewDidLoad()
        }
    }
}
