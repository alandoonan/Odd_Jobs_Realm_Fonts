//
//  SearchBarExtension.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 03/10/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

//MARK: UIViewController additional functions
extension UISearchBar {
    
    //MARK: Search Bar Functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String, searchFilter: String) {
        print("typing in search bar: term = \(searchText)")
        if searchText != "" {
            let predicate = NSPredicate(format:searchFilter, searchText, searchText, viewScoreCateogry, (SyncUser.current?.identity)!)
            self.items = realm.objects(OddJobItem.self).filter(predicate)
            tableView.reloadData()
        } else {
            self.items = realm.objects(OddJobItem.self).filter(Constants.groupTaskFilter, viewScoreCateogry, (SyncUser.current?.identity)!)
            tableView.reloadData()
        }
        tableView.reloadData()
    }
    
}
