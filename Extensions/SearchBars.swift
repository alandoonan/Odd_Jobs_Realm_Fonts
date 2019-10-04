//
//  SearchBar.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 03/10/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    //MARK: Adds a search bar with place holder based on task category
    func addSearchBar(scoreCategory: [String], searchBar: UISearchBar) {
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false
        searchBar.placeholder = "Search " + scoreCategory.joined(separator:" ")
    }
}

extension UISearchBarDelegate {
    func setUpSearchBar(searchBar: UISearchBar) {
        searchBar.delegate = self
    }
}

