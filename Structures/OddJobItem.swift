//
//  OddJobItem.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import RealmSwift

class OddJobItem: Object {
    
    @objc dynamic var itemId: String = UUID().uuidString
    @objc dynamic var ListID: Int = 0
    @objc dynamic var Name: String = ""
    @objc dynamic var Priority: String = ""
    @objc dynamic var IsDone: Bool = false
    @objc dynamic var Timestamp: Date = Date()
    @objc dynamic var Occurrence: String = ""
    @objc dynamic var Location: String = ""
    @objc dynamic var Category: String = ""
    @objc dynamic var LifeCategory: String = ""
    @objc dynamic var Latitude = 0.0
    @objc dynamic var Longitude = 0.0
    @objc dynamic var DueDate = ""
    @objc dynamic var User = ""
    override static func primaryKey() -> String? {
        return "itemId"
    }
}
