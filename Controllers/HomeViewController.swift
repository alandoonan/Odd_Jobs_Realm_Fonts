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
    
//    var personalController: PersonalViewController?
//    var groupController: GroupViewController?
//    var lifeController: LifeViewController?
//    var subViewControllers: [UIViewController] = []
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = UINavigationController(rootViewController: PersonalViewController())
        let vc2 = UINavigationController(rootViewController: GroupViewController())
        let vc3 = UINavigationController(rootViewController: LifeViewController())
        
        viewControllers = [vc1, vc2, vc3]
        
        self.view.backgroundColor = .white
//        personalController = PersonalViewController()
//        groupController = GroupViewController()
//        lifeController = LifeViewController()
//        
//        subViewControllers.append(personalController!)
//        subViewControllers.append(groupController!)
//        subViewControllers.append(lifeController!)
//        
//        personalController?.tabBarItem.tag = 0
//        groupController?.tabBarItem.tag = 1
//        lifeController?.tabBarItem.tag = 2
        
        
        
        viewControllers = [vc1, vc2, vc3]
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
