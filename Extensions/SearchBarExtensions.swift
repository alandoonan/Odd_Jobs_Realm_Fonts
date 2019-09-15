//
//  SearchBarExtensions.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 15/09/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

class SearchBarExtensions: UISearchBar {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}
