//
//  Constants.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 07/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import Foundation
import RealmSwift

struct Constants {
    //Realm URLs
    static let MY_INSTANCE_ADDRESS = "odd-jobs.de1a.cloud.realm.io"
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let ODDJOBS_REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/~/Oddjobs")!
    
    //Theme Colours
    static let themeColours = ["Blue" : "20A4F3", "Dark": "453823","Green": "31BC53","Orange": "E07A5F"]
    
    //Alert Fields
    static let personalAlertFields = ["Odd Job Name","Odd Job Priority","Odd Job Occurrence","Odd Job Location"]
    
    //Sort Fields
    let sortFields: [String] = ["Name", "Priority", "Occurrence"]
    
    //List Types
    static let listTypes = ["Group","Life","Personal"]

}
