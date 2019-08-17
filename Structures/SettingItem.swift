//
//  OddJobItem.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import RealmSwift

class SettingItem: Object {
    @objc dynamic var settingID: String = UUID().uuidString
    @objc dynamic var tag: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var settingType: String = ""
    @objc dynamic var Category: String = "Setting"
    override static func primaryKey() -> String? {
        return "settingID"
    }
}
