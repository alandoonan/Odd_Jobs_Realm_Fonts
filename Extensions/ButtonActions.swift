//
//  ButtonActions.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 03/10/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: Button press function to present the Life Task Creation option to the user
    @objc func addLifeTaskPassThrough() {
        showStoryBoardView(storyBoardID: "LifeTaskViewController")
    }
}
