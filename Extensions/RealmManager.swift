//
//  RealmManager.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 18/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager {
    
    let realm = try! Realm()
    
    /**
     Delete local database
     */
    func deleteDatabase() {
        try! realm.write({
            realm.deleteAll()
        })
    }
    
    /**
     Save array of objects to database
     */
    func saveItems(item: [Object]) {
        try! realm.write({
            // If update = true, objects that are already in the Realm will be
            // updated instead of added a new.
            realm.add(item)
        })
    }
    
    /**
     Returs an array as Results<Object>?
     */
    func getItems(item: Object.Type) -> Results<Object>? {
        return realm.objects(item)
    }
}
