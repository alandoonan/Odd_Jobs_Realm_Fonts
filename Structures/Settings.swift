//
//  OddJobItem.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import RealmSwift

class Settings: Object {
    
    @objc dynamic var settingID: String = UUID().uuidString
    @objc dynamic var colour: String = "Select Colour"
    @objc dynamic var deleteAccount: String = "Delete Account"
    
    
    override static func primaryKey() -> String? {
        return "settingID"
    }
    
}
