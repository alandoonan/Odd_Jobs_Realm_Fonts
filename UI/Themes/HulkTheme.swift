//
//  HulkTheme
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 11/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit

class HulkTheme: ThemeProtocol {
    var mainFontName: String = ""
    var textColour: UIColor = UIColor.white
    var accent: UIColor = UIColor.purpleTheme
    var background: UIColor = UIColor.hulkTheme
    var tint: UIColor = UIColor.purpleTheme
    var done: UIColor = UIColor.purpleTheme
    var undone: UIColor = .gray
    var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
