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
    static let themeColours = ["Blue": ["20A4F3","10","1","BlueTheme","282b35"], "Dark": ["282b35","20","2","DarkTheme","E07A5F"], "The Hulk": ["9bc063","30","3","HulkTheme","34314C"], "Orange": ["E07A5F","40","4","OrangeTheme","282b35"],"Batman": ["FDFF00","50","5","BatmanTheme","000000"]]

    //Theme Unlock Levels
    static let themeLevels = ["Blue" : BlueTheme(), "Dark": DarkTheme(),"The Hulk": HulkTheme(),"Orange": OrangeTheme(), "Batman": BatmanTheme()] as [String : Any]
    
    //Alert Fields
//    static let personalAlertFields = ["Odd Job Name","Odd Job Priority","Odd Job Occurrence","Odd Job Location"]
//    static let groupAlertFields = ["Odd Job Name","Odd Job Priority","Odd Job Occurrence","Odd Job Location"]
//    static let lifeAlertFields = ["Odd Job Name","Odd Job Occurrence","Life Area"]

    //Sort Fields
    static let sortFields: [String] = ["Name", "Priority", "Occurrence"]
    
    //List Types
    static let listTypes = ["Group","Life","Personal","Work"]
    
    //Create Task Categories
    static let createTaskTypes = ["Group","Personal","Work"]
    
    //Map Pin Icons
    static let mapPins = ["Personal" : "P.png", "Group": "G.png", "Life" : "L.png", "Work" : "W.png"]
    
    //Task Filters
    static let taskFilter = "Category in [c] %@ and IsDone == false"
    static let taskDoneFilter = "Category in[c] %@ and IsDone == true"
    
    //Search Filter
    static let searchFilter = "(Name CONTAINS[c] %@ OR Occurrence CONTAINS[c] %@) AND Category in %@ AND IsDone == false"
    static let doneSearchFilter = "(Name CONTAINS[c] %@ OR Occurrence CONTAINS[c] %@) AND Category in %@ AND IsDone == true"
    
    //Cell Fields
    static let cellFields = ["Location","Occurence","Due Date"]
    static let doneSwipe = "Done"
    static let undoneSwipe = "Undone"
    
    //Score Updates
    static let increaseScore = 1
    static let descreaseScore = -1
    
    //Score Categories
    static let archiveScoreCategory = ["Archive"]
    static let personalScoreCategory = ["Personal"]
    static let groupScoreCategory = ["Group"]
    static let lifeScoreCategory = ["Life"]
    static let workScoreCategory = ["Work"]
    
    //Task Data
    static let taskData = [["Health", "Social", "Finance", "Birthday", "Anniversary","Custom"],["No Smoking","Drink Water","Go For A Walk","Eat A Healthy Meal"],["Call A Friend","Go Visit A Family Member","Do Something Nice For Somebody"],["Save Small Sum Of Money","Pay A Bill"],["Partners Birthday","Childs Birthday","Mothers Birthday","Fathers Birthday"],["Wedding","Couple","Passed Family Member or Friend","Parents Wedding"],["Test"],["Daily","Weekly","Monthly","Yearly"]]
    
    static let taskPriority = ["Low","Medium","High","Urgent"]
    
    var scoreItem: Results<ScoreItem>
    var themes: Results<ThemeItem>
    
    func commonRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_USERS_URL, fullSynchronization: true)
        return config!
    }
    
    func tasksRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        return config!
    }
    
    

}
