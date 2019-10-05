//
//  User.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 04/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import RealmSwift

class UserItem: Object {
    
    @objc dynamic var UserTag: String = UUID().uuidString
    @objc dynamic var UserID: String = ""
    @objc dynamic var Name: String = ""
    @objc dynamic var Category = "User"
    override static func primaryKey() -> String? {
        return "UserTag"
}
}
