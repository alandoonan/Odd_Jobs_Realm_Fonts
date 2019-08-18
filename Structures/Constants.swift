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
    static let ODDJOBS_REALM_USERS_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/Users-Shared")!
    
    
    //Theme Colours
    //static let themeColours = ["Blue" : "20A4F3", "Dark": "453823","Green": "31BC53","Orange": "E07A5F"]
    static let themeColours = ["Blue": ["20A4F3","10","1","BlueTheme"], "Dark": ["453823","20","2","DarkTheme"], "Green": ["31BC53","30","3","GreenTheme"], "Orange": ["E07A5F","40","4","OrangeTheme"]]

    //Theme Unlock Levels
    static let themeLevels = ["Blue" : BlueTheme(), "Dark": DarkTheme(),"Green": GreenTheme(),"Orange": OrangeTheme()] as [String : Any]
    
    //Alert Fields
    //Personal
    static let personalAlertFields = ["Odd Job Name","Odd Job Priority","Odd Job Occurrence","Odd Job Location"]
    //Group
    static let groupAlertFields = ["Odd Job Name","Odd Job Priority","Odd Job Occurrence","Odd Job Location"]
    //Life
    static let lifeAlertFields = ["Odd Job Name","Odd Job Occurrence","Life Area"]

    //Sort Fields
    static let sortFields: [String] = ["Name", "Priority", "Occurrence"]
    
    //List Types
    static let listTypes = ["Group","Life","Personal"]
    
    func commonRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_USERS_URL, fullSynchronization: true)
        return config!
    }
    
    func tasksRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        return config!
    }

}
