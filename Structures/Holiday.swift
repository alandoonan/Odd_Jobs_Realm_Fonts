//
//  Holiday.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 09/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

struct Holiday {
    
    // some holiday names are provided with an "observed" suffix - so we define a base name (without this suffix) to more easily compare dates
    let baseName: String
    let name: String
    let start: String
    let end: String
    
    let observedKeyword: String = "observed"
    
    // let dates with the "observed" keyword take priority (override) for a specific holiday date
    var isOverride: Bool {
        get {
            return self.name.contains(observedKeyword)
        }
    }
    
    
    init(name: String, start: String, end: String) {
        self.name = name
        self.start = start
        self.end = end
        
        let components = name.split(separator: " ")
        if let last = components.last, last == observedKeyword {
            self.baseName = components.dropLast().joined(separator: " ")
        }
        else {
            self.baseName = name
        }
    }
    
    init(date: String) {
        self.init(name: "", start: date, end: date)
    }
}
