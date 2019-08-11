//
//  SettingCell.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 11/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//
import UIKit

class SettingCell: UITableViewCell {
    
    var settingsLabel: UILabel!
    var newSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //The rect does not seems to be correct. This will go way beyond the cell rect.
        //may be use UISwitch(frame:CGRectMake(150, 10, 0, 0))
        newSwitch = UISwitch(frame:CGRect(x: 150, y: 300, width: 0, height: 0))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK: - custom
    
    func setCell(labelText: String, activeBool: Bool) {
        self.settingsLabel.text = labelText
        newSwitch.isOn = activeBool
        newSwitch.setOn(activeBool, animated: true)
        
        //Add to contentView instead of self.
        contentView.addSubview(newSwitch)
    }
}
