//
//  LoginViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 02/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift
import Realm


class LoginViewController: UIViewController {
    
    
    
    var username: String = ""
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("Login Button Pressed")
        let username = emailTextField.text!
        let password = passTextField.text!
        let creds    = SyncCredentials.usernamePassword(username: username, password: password, register: false)
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
            if let _ = user {
                self?.navigationController?.pushViewController(HomeViewController(), animated: true)
                print(username + " has logged in with password " + password)
            } else if let error = err {
                print("Error Logging In.")
                print(error)
                self?.passTextField.shake()
                let alertController = UIAlertController(title: "Oops!", message: "Incorrect username or password. Try again.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self?.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func newUserButtonPressed(_ sender: Any) {
        print("New User Button Pressed")
        username = emailTextField.text!
        let password = passTextField.text!
        let creds    = SyncCredentials.usernamePassword(username: username, password: password, register: true)
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
            if let _ = user {
                self?.navigationController?.pushViewController(HomeViewController(), animated: true)
                print(self!.username + " has been created with password " + password)
            } else if let error = err {
                fatalError(error.localizedDescription)
            }
        })
    }
    
    // Change Current User Password
    @IBAction func changePassButtonPressed(_ sender: Any) {
        print("Change Password Button Pressed")
        let alert = UIAlertController(title: "Change Password", message: "Enter new password.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter New Password"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Text field: " + textField!.text!)
            let newPassword = textField!.text!
            print(newPassword)
            SyncUser.current!.changePassword(newPassword) { (error) in
                if error != nil {
                    print("Error")
                }
                else {
                    print("Password changed successfully")
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetPassButtonPressed(_ sender: Any) {
        print("Request Password Reset Button Pressed")
        let usernameRequest = emailTextField.text!
        print(usernameRequest)
        SyncUser.requestPasswordReset(forAuthServer: Constants.AUTH_URL, userEmail: "alandoonan@gmail.com"){ error in
            if (error != nil) {
                print(error!)
                print("Error Requesting Password")
            }
        }
        let token = "resetToken"
        let newPassword = "newPassword"
        SyncUser.completePasswordReset(forAuthServer: Constants.AUTH_URL, token: token, password: newPassword) { error in
            if (error != nil) {
                print("Error changing password")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for u in SyncUser.all {
            u.value.logOut()
        }
        view.backgroundColor = UIColor.navyTheme
        title = "Login"
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
            }
    }
    
}
