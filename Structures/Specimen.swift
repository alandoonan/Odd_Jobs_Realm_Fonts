//
//  Specimen.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 10/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import Foundation
import RealmSwift

class Specimen: Object {
    @objc dynamic var name = ""
    @objc dynamic var specimenDescription = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var created = Date()
    
    @objc dynamic var category: Category!
}
