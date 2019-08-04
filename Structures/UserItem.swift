//
//  User.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 04/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import RealmSwift

class UserItem: Object {
    
    @objc dynamic var userID: String = UUID().uuidString
    @objc dynamic var Name: String = ""
    @objc dynamic var Category: String = "User"

    override static func primaryKey() -> String? {
        return "userID"
}
}
