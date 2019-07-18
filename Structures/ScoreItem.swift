//
//  Scores.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 15/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import RealmSwift

class ScoreItem: Object {
    
    @objc dynamic var scoreId: String = UUID().uuidString
    @objc dynamic var Name: String = ""
    @objc dynamic var Score: Int = 0
    @objc dynamic var Category: String = "Score"

    
    override static func primaryKey() -> String? {
        return "scoreId"
    }
    
    func save() -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
            return true
        } catch let error as NSError {
            print(">>> Realm Error: ", error.localizedDescription)
            return false
        }
    }
    
}
