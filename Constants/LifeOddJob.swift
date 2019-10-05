//
//  LifeOddJob.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 11/09/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import RealmSwift

class OddJobItem: Object {
    
    @objc dynamic var itemId: String = UUID().uuidString
    @objc dynamic var Name: String = ""
    @objc dynamic var Priority: String = ""
    @objc dynamic var IsDone: Bool = false
    @objc dynamic var Timestamp: Date = Date()
    @objc dynamic var Occurrence: String = ""
    @objc dynamic var Category: String = ""
    @objc dynamic var LifeCategory: String = ""
    @objc dynamic var HolidayDate = ""
    override static func primaryKey() -> String? {
        return "itemId"
    }
}
