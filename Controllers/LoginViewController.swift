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
    let tableView = UITableView()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginButton: UI!
    
    @IBOutlet weak var newUserButton: UI!
    
    @IBOutlet weak var changePasswordButton: UI!
    
    @IBOutlet weak var passwordResetButton: UI!
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("Login Button Pressed")
        let username = emailTextField.text!
        let password = passTextField.text!
        currentUserSync(username, password)
        sharedUser = username
        UserDefaults.standard.set(username, forKey: "Name")
        print("Shared User Login VC: " + sharedUser)
    }
    
    @IBAction func newUserButtonPressed(_ sender: Any) {
        print("New User Button Pressed")
        let username = emailTextField.text!
        let password = passTextField.text!
        newUserSync(username, password)
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
    
    
    
    
    fileprivate func storeUserInformation(username: String) {
        print("Storing User Information")
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_USERS_URL, fullSynchronization: true)
        let realm = try! Realm(configuration: config!)
        print(realm)
        let item = UserItem()
        item.UserID = (SyncUser.current?.identity!)!
        item.Name = username
        try! realm.write {
            realm.add(item)
            print("User Added")
            print(item)
        }
    }
    
    func animateCell(_ background: UIViewController) {
        
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [.transitionCrossDissolve, .allowAnimatedContent], animations: {
            self.view.backgroundColor = .red
        }) { (_) in
            UIView.animate(withDuration: 5.0, animations: {
                self.view.backgroundColor = .black
            })
        }
        
    }
    
    func currentUserSync(_ username: String, _ password: String) {
        let creds = SyncCredentials.usernamePassword(username: username, password: password, register: false)
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
            if let _ = user {
                print(username + " has logged in with password " + password)
                if username == "alandoonan" {
                    self!.openSharedRealm()
                    self!.logOutButtonPress()
                }
                self!.getHolidayData()
                self?.transition()
                self?.navigationController?.pushViewController(HomeViewController(), animated: true)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }
    
    
    
    func openRealmPermissions () {
        let userRealm = "/~/Oddjobs"
        let permission = SyncPermission(realmPath: userRealm.replacingOccurrences(of: "~", with: String((SyncUser.current?.identity)!)), identity: "*", accessLevel: .write)
        print(permission)
        print("Applying Permissions")
        SyncUser.current?.apply(permission) { error in
          if let error = error {
            // handle error
            print(error)
            return
          }
            print("Permission applied")
          // permission was successfully applied
        }
    }
    
    func openSharedRealm () {
        let userRealm = "/Oddjobs_Users"
        let permission = SyncPermission(realmPath: userRealm, identity: "*", accessLevel: .write)
        print(permission)
        print("Applying Permissions")
        SyncUser.current?.apply(permission) { error in
          if let error = error {
            // handle error
            print("ERROR ERROR ERROR ERROR")
            print(error)
            return
          }
            print("Permission applied")
          // permission was successfully applied
        }
    }
    
    
    func requestEmailConfirmation (_ username: String) {
        let email = username
        SyncUser.requestEmailConfirmation(forAuthServer: Constants.AUTH_URL, userEmail: email) { error in
            if (error != nil) {
                print(error!)
                print("ERROR GETTING EMAIL")
            }
        }
    }
    
    fileprivate func newUserSync(_ username: String, _ password: String) {
        let creds    = SyncCredentials.usernamePassword(username: username, password: password, register: true)
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
            if let _ = user {
                self?.navigationController?.pushViewController(HomeViewController(), animated: true)
                print(username + " has been created with password " + password)
                self!.storeUserInformation(username: username)
                self!.requestEmailConfirmation(username)
                self!.openRealmPermissions()
                self!.checkingScoreSystem()
                self!.transition()
            } else if let error = err {
                print(error)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        applyThemeView(view)
        UITextField.appearance().keyboardAppearance = .dark
        loginButton.titleLabel?.font = UIFont(name: Themes.mainFontName,size: 18)
        newUserButton.titleLabel?.font = UIFont(name: Themes.mainFontName,size: 18)
        changePasswordButton.titleLabel?.font = UIFont(name: Themes.mainFontName,size: 18)
        passwordResetButton.titleLabel?.font = UIFont(name: Themes.mainFontName,size: 18)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyThemeView(view)
        
        logOutUsers()
        if let _ = SyncUser.current {
            print("Already Logged In.")
            self.navigationController?.pushViewController(HomeViewController(), animated: true)
        }
    }
}
