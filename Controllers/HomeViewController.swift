//
//  HomeViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 09/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class HomeViewController: UITabBarController {
    
    let scoreVC = ScoreViewController()
    
    let key = "d2830f02-e3fc-4ea3-a3a7-f07c589119e5"
    let secret = "8XuXAs8K37ejtYqvsEue2p"
    let url = URL(string: "https://holidayapi.com/v1/holidays")
    let country = "IE"
    let year = "2018"
    
    let session = URLSession.shared
    
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
        let settingsTab = UINavigationController(rootViewController: SettingsViewController())
        let scoreTab = UINavigationController(rootViewController: ScoreViewController())
        self.view.backgroundColor = UIColor.navyTheme
        viewControllers = [groupTab,personalTab, lifeTab,settingsTab,scoreTab]

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Test")
        getHolidayData()
        
    }
    
    func getHolidayData () {
        print("Getting Holiday Data")
        let locale = Locale.current
        print(locale.regionCode!)
        //let parameters = ["key": key]
        
        let params = [
            "key": key,
            "country": "IE",
            "year" : year
        ]

        Alamofire.request(url!, parameters: params).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                //print(json)
                print(json["holidays"])
                //print(json["observed"])
            }
        }
}
    
}
