//
//  RealmManager.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 18/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

extension UIViewController {
    
    //MARK: Delete the pass OddJobItem via user swipe or programatically
    func deleteOddJob(_ indexPath: IndexPath, realm: Realm, items: Results<OddJobItem>) {
        let item = items[indexPath.row]
        try! realm.write {
            realm.delete(item)
        }
    }
    
    //MARK: Logs out all users on application login. This is mainly for testing purporses
    func logOutUsers() {
        print("Logging out users.")
        for u in SyncUser.all {
            print("Logging out user: " + String(u.value.identity!))
            u.value.logOut()
        }
    }
    
    /* MARK: Finds an OddJobItem by passing the items name. This will search the current Realm
     for an object and return it to the user */
    func findOddJobItemByName(_ Name: String, realm: Realm) -> Results<OddJobItem> {
        let predicate = NSPredicate(format: "Name = %@ and User in [c] %@", Name, [UserDefaults.standard.string(forKey: "Name") ?? ""])
        return realm.objects(OddJobItem.self).filter(predicate)
    }
    
    /* MARK: Finds a theme item in the users Realm and returns it to the user */
    func findColourByName(_ Name: String, realm: Realm) -> Results<ThemeItem>
    {
        let predicate = NSPredicate(format: "name = %@", Name)
        return realm.objects(ThemeItem.self).filter(predicate)
    }
}
