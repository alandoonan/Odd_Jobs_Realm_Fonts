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
    static let themeColours = ["Blue": ["20A4F3","10","1","BlueTheme"], "Dark": ["453823","20","2","DarkTheme"], "The Hulk": ["31BC53","30","3","HulkTheme"], "Orange": ["E07A5F","40","4","OrangeTheme"],"Batman": ["31BC53","30","3","BatmanTheme"]]

    //Theme Unlock Levels
    static let themeLevels = ["Blue" : BlueTheme(), "Dark": DarkTheme(),"The Hulk": HulkTheme(),"Orange": OrangeTheme(), "Batman": BatmanTheme()] as [String : Any]
    
    //Alert Fields
    static let personalAlertFields = ["Odd Job Name","Odd Job Priority","Odd Job Occurrence","Odd Job Location"]
    static let groupAlertFields = ["Odd Job Name","Odd Job Priority","Odd Job Occurrence","Odd Job Location"]
    static let lifeAlertFields = ["Odd Job Name","Odd Job Occurrence","Life Area"]

    //Sort Fields
    static let sortFields: [String] = ["Name", "Priority", "Occurrence"]
    
    //List Types
    static let listTypes = ["Group","Life","Personal"]
    
    //Create Task Categories
    static let createTaskTypes = ["Group","Personal"]
    
    //Map Pin Icons
    static let mapPins = ["Personal" : "P.png", "Group": "G.png", "Life" : "L.png"]
    
    //Cell Fields
    static let cellFields = ["Priority","Location"]
    
    //Task Data
    static let taskData = [["Health", "Social", "Finance", "Birthday", "Anniversary","Custom"],["No Smoking","Drink Water","Go For A Walk","Eat A Healthy Meal"],["Call A Friend","Go Visit A Family Member","Do Something Nice For Somebody"],["Save Small Sum Of Money","Pay A Bill"],["Partners Birthday","Childs Birthday","Mothers Birthday","Fathers Birthday"],["Wedding","Couple","Passed Family Member or Friend","Parents Wedding"],["Test"],["Daily","Weekly","Monthly","Yearly"]]
    
    static let taskPriority = ["Low","Medium","High","Urgent"]
    
    func commonRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_USERS_URL, fullSynchronization: true)
        return config!
    }
    
    func tasksRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        return config!
    }

}
