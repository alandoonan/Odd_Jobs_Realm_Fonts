//
//  HolidayAPI.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 30/09/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

extension UIViewController {

//MARK: Holiday API Functions
func getHolidayData () {
    print("Getting Holiday Data")
    let locale = Locale.current.regionCode!
    print(locale)
    let params = [
        "key": HolidayItem.key,
        "country": "IE",
        "year" : HolidayItem.year,
        "upcoming" : HolidayItem.upcoming,
        "pretty": HolidayItem.pretty,
        "public": false,
        "month" : calendar.component(.month, from: date)
        ] as [String : Any]
    Alamofire.request(HolidayItem.url!, parameters: params).responseJSON { response in
        if let result = response.result.value {
            let json = JSON(result)
            for holiday in json["holidays"].arrayValue
            {
                if  let name = holiday["name"].string,
                    let date = holiday["date"].string {
                    self.holidayDictionary[name] = date
                }
            }
            self.addHolidayData(holidayDictionary: self.holidayDictionary, realm: self.realm)
        }
    }
}
