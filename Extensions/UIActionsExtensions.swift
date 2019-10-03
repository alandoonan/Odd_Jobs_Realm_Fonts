//
//  UIViewControllerExtensions.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 10/09/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: Sidebar transistion
    func transition() {
        let homeVC:SideBarController = SideBarController()
        present(homeVC, animated: true, completion: nil)
    }
    
    //MARK: Dismiss keyboard when anywhere else in view is touched
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //MARK: Dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: Returns back to previous view
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            print("Return Home Pop")
            nav.popViewController(animated: true)
        } else {
            print("Return Home Dismiss")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Moves to a passed view when storyboard ID is passed
    func showStoryBoardView(storyBoardID: String) {
        print("Go to Storyboard Button Pressed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyBoardID)
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: Moves to the task create view and uses the task category of the current view to populate task view
    func presentTaskCreateController(storyBoardID: String, taskType: String) {
        print("Go to Storyboard Button Pressed")
        print(taskType)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyBoardID)
        if let controller = storyboard.instantiateViewController(withIdentifier: storyBoardID) as? CreateTaskViewController {
            controller.taskType = taskType
            self.present(controller, animated: true)
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: Dismisses the current pop up view controller
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
}
