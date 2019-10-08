//
//  UI.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 10/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//
import UIKit

@IBDesignable
class UI: UIButton {
    
    
    
    /* MARK: Allows the ability to add curved button customization via the
     storyboard and also programatically */
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
