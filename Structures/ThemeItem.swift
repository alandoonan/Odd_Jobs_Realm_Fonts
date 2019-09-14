//
//  ThemeItem.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 16/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import RealmSwift

class ThemeItem: Object {
    @objc dynamic var themeID: String = UUID().uuidString
    @objc dynamic var tag: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var hexColour: String = ""
    @objc dynamic var Category: String = "Theme"
    @objc dynamic var UnlockLevel: Int = 0
    @objc dynamic var CellColour: String = ""
    @objc dynamic var userAlerted: Bool = false
    override static func primaryKey() -> String? {
        return "themeID"
    }
}

