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
    // **** Realm Cloud Users:
    // **** Replace MY_INSTANCE_ADDRESS with the hostname of your cloud instance
    // **** e.g., "mycoolapp.us1.cloud.realm.io"
    // ****
    // ****
    // **** ROS On-Premises Users
    // **** Replace the AUTH_URL and REALM_URL strings with the fully qualified versions of
    // **** address of your ROS server, e.g.: "http://127.0.0.1:9080" and "realm://127.0.0.1:9080"
    
    static let MY_INSTANCE_ADDRESS = "odd-jobs.de1a.cloud.realm.io" // <- update this
    
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    //Personal Lists Realm URL
    static let PERSONAL_REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/~/Personal_Lists")!
    
    //Group Lists Realm URL
    static let GROUP_REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/~/Group_Lists")!

    //Life Lists Realm URL
    static let LIFE_REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/~/Life_Lists")!
    
    //Settings Realm URL
    static let SETTINGS_REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/~/Settings")!
    
    //Settings Realm URL
    static let SCORE_REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/~/Score")!

}
