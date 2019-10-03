//
//  NavBars.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 03/10/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //Add a navigation bar to the current view. Allows users to add left and right buttons and and custom title
    func addNavBar(_ leftButtons: [UIBarButtonItem], _ rightButtons: [UIBarButtonItem], scoreCategory: [String]) {
        navigationItem.leftBarButtonItems = leftButtons
        navigationItem.rightBarButtonItems = rightButtons
        navigationItem.title = scoreCategory.joined(separator:" ")
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
