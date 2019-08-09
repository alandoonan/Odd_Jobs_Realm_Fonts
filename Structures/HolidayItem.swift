//
//  Holiday.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 09/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import Foundation

struct HolidayItem {
    /* Structure to deal with Rest API request to Holiday API.
     This will need to be enabled to only accept upcoming dates
     in the year
    */
    static var key = "d2830f02-e3fc-4ea3-a3a7-f07c589119e5"
    static var secret = "8XuXAs8K37ejtYqvsEue2p"
    static var url = URL(string: "https://holidayapi.com/v1/holidays")
    static var country = ""
    static var year = "2018"
    static var upcoming = false
    static var pretty = true
}
