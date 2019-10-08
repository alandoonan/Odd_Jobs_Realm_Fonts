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
    
    //MARK: Present alert to the user on task creation based on task type
    func taskCreatedAlert (taskType: String, taskName: String) {
        let alertController = UIAlertController(title: taskType + " Item Created", message: taskName, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Create Another Task", style: .default, handler: {
            alert -> Void in
        }))
        alertController.addAction(UIAlertAction(title: "Done", style: .destructive, handler: {
            alert -> Void in
            self.performSegueToReturnBack()
        }))
        playSound(soundName: "task_created.mp3")
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Life Task Alert Invalid Selection
    func invalidLifeSelection (selection: String) {
        let alertController = UIAlertController(title: selection + " Not Selected", message: "Please Select A " + selection, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: {
            alert -> Void in
            print("ERROR")
        }))
        playSound(soundName: "task_created.mp3")
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Action to perform logout for current user when logout button is pressed
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
    
    @objc func deleteAllTasksButtonPress() {
        let alertController = UIAlertController(title: "Empty Archive", message: "", preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "Yes, Empty.", style: .destructive, handler: {
            alert -> Void in
            self.emptyPersonalArchivedTasks()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: false, completion: nil)
    }
    
    @objc func deleteAllGroupTasksButtonPress() {
        let alertController = UIAlertController(title: "Empty Archive", message: "", preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "Yes, Empty.", style: .destructive, handler: {
            alert -> Void in
            self.emptyGroupArchivedTasks()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: false, completion: nil)
    }
}
