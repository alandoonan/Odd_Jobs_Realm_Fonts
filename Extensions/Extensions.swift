//
//  Extensions.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 28/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

//MARK: UIColor Addtional Settings
extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
}

extension UITableView {
    func addTableView(_ tableView: UITableView, _ view: UIView) {
        tableView.backgroundColor = Themes.current.background
        tableView.frame = view.frame
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.addSubview(tableView)
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

extension UISearchBarDelegate {
    func setUpSearchBar(searchBar: UISearchBar) {
        searchBar.delegate = self
    }
}





