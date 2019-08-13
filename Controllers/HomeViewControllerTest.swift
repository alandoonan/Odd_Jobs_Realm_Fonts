//
//  HomeViewControllerTest.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 13/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

class HomeControllerTest: UIViewController {
    
    var delegate: HomeControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.navyTheme
        configureNavigationBar()
    }
        
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.navyTheme
        navigationController?.navigationBar.barStyle = .black
        navigationController?.view.backgroundColor = UIColor.navyTheme
        
        navigationItem.title = "Odd Jobs"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }
}
