//
//  EditOddJobFooter.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 21/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//


import UIKit

fileprivate extension Selector {
    static let footerTapped = #selector(EditToDoTableFooter.footerTapped(_:))
}

class EditOddJobFooter: UIView {
    
    typealias TappedClosure = (EditToDoTableFooter)->Void
    
    var action: TappedClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.isHidden = false
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: .footerTapped, for: .touchUpInside)
        
        addSubview(button)
        
        button.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7).cgColor
        button.layer.shadowRadius = 0.5
        button.setTitle("Add Category", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
    }
    
    @objc fileprivate func footerTapped(_ sender: UIButton) {
        action?(self)
    }
}
