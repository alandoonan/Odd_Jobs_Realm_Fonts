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
    @objc dynamic var name: String = ""
    @objc dynamic var priority: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var timestamp: Date = Date()
    @objc dynamic var occurrence: String = ""

    override static func primaryKey() -> String? {
        return "itemId"
    }
    
}
