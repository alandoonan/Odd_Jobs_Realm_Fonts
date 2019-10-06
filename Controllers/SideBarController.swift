//
//  SideBarController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 13/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

class SideBarController: UIViewController {
    
    let scoreVC = ScoreViewController()
    var menuController: MenuController!
    var centerController: UIViewController!
    var isExpanded = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        applyThemeView(view)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyThemeView(view)
        configureHomeController()

    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    func configureHomeController() {
        let homeController = HomeViewControllerTest()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        animateStatusBar()
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .Lists:
            print("Lists")
            let tabBar = HomeViewController()
            present(tabBar, animated: true, completion: nil)
        case .PersonalArchive:
            print("Personal Archive}")
            let controller = DoneViewController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .GroupArchive:
            print("Group Archive}")
            let controller = GroupArchiveViewController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .ScoreBoard:
            print("ScoreBoard")
            showStoryBoardView(storyBoardID: "ScoreBoardViewController")
//        case .Score:
//            print("Score")
//            let controller = ScoreViewController()
//            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .Themes:
            print("Themes")
            let controller = ThemesViewController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .Locations:
            print("Locations")
            showStoryBoardView(storyBoardID: "MapTasksViewController")
        case .Users:
            print("Users")
            let controller = SearchUsersViewController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
//        case .CreateLifeTask:
//            print("Create Life Task")
//            showStoryBoardView(storyBoardID: "LifeTaskViewController")
//        case .CreateTask:
//            print("Create Task")
//            showStoryBoardView(storyBoardID: "CreateTaskViewController")
        case .Logout:
            print("Log Out")
            logOutButtonPress()
        
        }
}
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

extension SideBarController: HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            print("Expanded")
            configureMenuController()
        }
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
}

extension SideBarController: UIGestureRecognizerDelegate {
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
    }
}
