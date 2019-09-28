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
    static let MY_INSTANCE_ADDRESS = "odd-jobs-realm.de1a.cloud.realm.io"
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let ODDJOBS_REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/~/Oddjobs")!
    static let ODDJOBS_REALM_USERS_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/Oddjobs_Users")!
    
    //Testing Realm Share
    static let ODDJOBS_TEST_SHARE_TASK_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/7be9e24f2eb5b04e28439f886dbdd444/Oddjobs")!
    
    //Theme Colours
    //static let themeColours = ["Blue" : "20A4F3", "Dark": "453823","Green": "31BC53","Orange": "E07A5F"]
    static let themeColours = ["Blue": ["20A4F3","10","1","Blue","282b35"],
                               "Dark": ["282b35","20","2","Dark","E07A5F"],
                               "Hulk": ["9bc063","30","3","HulkTheme","34314C"],
                               "Orange": ["E07A5F","40","4","OrangeTheme","282b35"],
                               "Batman": ["FDFF00","50","5","Batman","000000"]]

    //Theme Unlock Levels
    static let themeLevels = ["Blue" : Blue(),
                              "Dark": Dark(),
                              "The Hulk": Hulk(),
                              "Orange": Orange(),
                              "Batman": Batman()] as [String : Any]
    
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
    static let taskFilter = "Category in [c] %@ and IsDone == false AND User in [c] %@"
    static let taskDoneFilter = "Category in[c] %@ and IsDone == true AND User in [c] %@"
    static let summaryGroupTaskFilter = "Category in[c] %@ and IsDone == false"
    static let summaryGroupDoneTaskFilter = "Category in[c] %@ and IsDone == true"
    static let groupTaskFilter = "Category in[c] %@ and IsDone == false and SharedWith CONTAINS[c] %@"
    
    //Search Filter
    static let searchFilter = "(Name CONTAINS[c] %@ OR Occurrence CONTAINS[c] %@) AND Category in %@ AND IsDone == false and SharedWith CONTAINS[c] %@"
    static let doneSearchFilter = "(Name CONTAINS[c] %@ OR Occurrence CONTAINS[c] %@) AND Category in %@ AND IsDone == true"
    
    //Cell Fields
    static let cellFields = ["Location","Occurence","Due Date","Shared By"]
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
    static let taskData = [["Health", "Social", "Finance", "Birthday", "Anniversary","Custom"],
                           ["No Smoking","Drink Water","Go For A Walk","Eat A Healthy Meal"],
                           ["Call A Friend","Go Visit A Family Member","Do Something Nice For Somebody"],
                           ["Save Small Sum Of Money","Pay A Bill"],
                           ["Partners Birthday","Childs Birthday","Mothers Birthday","Fathers Birthday"],
                           ["Wedding","Couple","Passed Family Member or Friend","Parents Wedding"],
                           ["Test"],
                           ["Daily","Weekly","Monthly","Yearly"]]
    
    static let taskPriority = ["Low","Medium","High","Urgent"]
    
    //Project Name
    static let project_name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    static let project_name_theme = String(Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "") + "."
    
    func commonRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_USERS_URL, fullSynchronization: true)
        return config!
    }
    
    func tasksRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        return config!
    }
}
