//
//  Notifications.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 01/10/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

extension UIViewController {
    
    func taskCreatedAlert (taskType: String, taskName: String) {
        let alertController = UIAlertController(title: taskType + " Item Created", message: taskName, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Create Another Task", style: .default, handler: {
            alert -> Void in
        }))
        alertController.addAction(UIAlertAction(title: "Done", style: .destructive, handler: {
            alert -> Void in
            self.performSegueToReturnBack()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func logOutButtonPress() {
        let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "Yes, Logout", style: .destructive, handler: {
            alert -> Void in
            SyncUser.current?.logOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: false, completion: nil)
    }
}
