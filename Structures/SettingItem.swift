//
//  OddJobItem.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import RealmSwift

class SettingItem: Object {
    @objc dynamic var themeID: String = UUID().uuidString
    @objc dynamic var tag: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var IsDone: Bool = false
    @objc dynamic var settingType: String = ""
    @objc dynamic var hexColour: String = ""
    @objc dynamic var Category: String = "Setting"
    @objc dynamic var UnlockLevel: Int = 0
    override static func primaryKey() -> String? {
        return "themeID"
    }
}
