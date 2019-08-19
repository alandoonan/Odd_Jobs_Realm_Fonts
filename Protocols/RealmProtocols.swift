//
//  RealmProtocols.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 19/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

protocol RealmProtocols {
    func animateHidden(flag: Bool)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
}
    extension RealmProtocols {
    }
