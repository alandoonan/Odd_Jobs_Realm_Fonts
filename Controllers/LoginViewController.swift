//
//  LoginViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 02/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    var sharedUser: String = ""
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    fileprivate func storeUserInformation(username: String) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        let realm = try! Realm(configuration: config!)
        print(realm)
        let item = UserItem()
        item.UserID = (SyncUser.current?.identity!)!
        item.Name = username
        item.Category = "User"
        try! realm.write {
            realm.add(item)
        }
    }
    
    fileprivate func currentUserSync(_ username: String, _ password: String) {
        let creds    = SyncCredentials.usernamePassword(username: username, password: password, register: false)
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
            if let _ = user {
                self?.navigationController?.pushViewController(HomeViewController(), animated: true)
                print(username + " has logged in with password " + password)
                self!.storeUserInformation(username: username)
                self!.transition()
            }
            else if let error = err {
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
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("Login Button Pressed")
        let username = emailTextField.text!
        let password = passTextField.text!
        currentUserSync(username, password)
        sharedUser = username
        UserDefaults.standard.set(username, forKey: "Name")
        print("Shared User Login VC: " + sharedUser)
    }
    
    fileprivate func newUserSync(_ username: String, _ password: String) {
        let creds    = SyncCredentials.usernamePassword(username: username, password: password, register: true)
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
            if let _ = user {
                self?.navigationController?.pushViewController(HomeViewController(), animated: true)
                print(username + " has been created with password " + password)
                self!.storeUserInformation(username: username)
                self!.transition()
            } else if let error = err {
                print(error)
            }
        })
    }
    
    @IBAction func newUserButtonPressed(_ sender: Any) {
        print("New User Button Pressed")
        let username = emailTextField.text!
        let password = passTextField.text!
        newUserSync(username, password)
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
    
    fileprivate func logOutUsers() {
        for u in SyncUser.all {
            print("Logging out user: " + String(u.value.identity!))
            u.value.logOut()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutUsers()
        view.backgroundColor = Themes.current.background
        if let _ = SyncUser.current {
            print("Already Logged In.")
            self.navigationController?.pushViewController(HomeViewController(), animated: true)
}
        print("Shared User Login VC: " + sharedUser)
}
    
//    func transition() {
//        let homeVC:HomeViewController = HomeViewController()
//        self.present(homeVC, animated: true, completion: nil)
//    }
    
    func transition() {
        let homeVC:SideBarController    = SideBarController()
        self.present(homeVC, animated: true, completion: nil)
    }
}
