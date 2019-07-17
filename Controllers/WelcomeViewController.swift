//
//  WelcomeViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import RealmSwift

class WelcomeViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(animated)
        title = "Welcome"
        if let _ = SyncUser.current {
            self.navigationController?.pushViewController(HomeViewController(), animated: true)
        } else {
            let alertController = UIAlertController(title: "Login to Odd Jobs", message: "Enter a Username", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Login", style: .default, handler: { [unowned self]
                alert -> Void in
                let textField = alertController.textFields![0] as UITextField
                let creds = SyncCredentials.nickname(textField.text!, isAdmin: true)
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
        }
    }
}
