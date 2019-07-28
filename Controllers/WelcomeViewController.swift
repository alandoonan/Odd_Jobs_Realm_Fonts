//
//  WelcomeViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import RealmSwift
import Realm

class WelcomeViewController: UIViewController {
    
//    let realm: Realm
//    var items: Results<User>
//    let nickname:String = ""
    
    override func viewDidLoad() {
        title = "Welcome"
        if let _ = SyncUser.current {
            self.navigationController?.pushViewController(HomeViewController(), animated: true)
        } else {
            let alertController = UIAlertController(title: "Login to Odd Jobs", message: "Enter a Username", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Login", style: .default, handler: { [unowned self]
                alert -> Void in
                let nickname = alertController.textFields![0] as UITextField
                let creds = SyncCredentials.nickname(nickname.text!, isAdmin: true)
                SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
                    if let _ = user {
                        self?.navigationController?.pushViewController(HomeViewController(), animated: true)
                    } else if let error = err {
                        fatalError(error.localizedDescription)
                    }
                })
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                textField.placeholder = "A Name for your user"
            })
            alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                textField.placeholder = "A Password for your user"
            })
            self.present(alertController, animated: true, completion: nil)
            //addUserDetails()
        }
    }

    //Score System Checks
//    fileprivate func addUserDetails() {
//        if let userItem = realm.objects(User.self).first
//        {
//            print("There is a user object")
//            print(realm.objects(User.self).count)
//        } else {
//            print("No first object!")
//            print("Creating user object")
//            let userItem = User()
//            userItem.Name = nickname
//            try! self.realm.write {
//                self.realm.add(userItem)
//            }
//        }
//    }
}
