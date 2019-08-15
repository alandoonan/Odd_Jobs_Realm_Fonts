//
//  SideBarController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 13/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

class SideBarController: UIViewController {
    
    let scoreVC = ScoreViewController()
    var menuController: MenuController!
    var centerController: UIViewController!
    var isExpanded = false
    
    fileprivate func setupNavBar() {
        // Navigation bar appearance
        let navigationAppearance = UINavigationBar.appearance()
        navigationAppearance.tintColor = UIColor.orangeTheme
        navigationAppearance.barTintColor = Themes.current.background
        navigationAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    @objc func searchOddJobs () {
        print("Search Odd Jobs")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureHomeController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    func configureHomeController() {
        let homeController = HomeControllerTest()
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
            // show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }, completion: nil)
            
        } else {
            // hide menu
            
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
        case .Score:
            print("Score")
            let controller = ScoreViewController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .Themes:
            print("Themes")
            let controller = SettingsViewController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .Settings:
            print("Settings")
            let controller = SettingsViewController()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
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
            configureMenuController()
        }
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
}
