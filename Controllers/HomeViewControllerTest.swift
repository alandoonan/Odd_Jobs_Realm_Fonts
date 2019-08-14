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
        view.backgroundColor = Themes.current.background
        configureNavigationBar()
    }
        
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = Themes.current.background
        navigationController?.navigationBar.barStyle = .black
        navigationController?.view.backgroundColor = Themes.current.background
        navigationItem.title = "Odd Jobs"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "iPhone App 60pt@2x.png")!)
    }
}
