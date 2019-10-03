//
//  TableViewAndCells.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 03/10/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

extension UIViewController {
    
    // MARK: Task cell setup and styling. This should change based on the category of task.
    func cellSetup(_ cell: UITableViewCell, _ item: OddJobItem, _ cellFields: [String]) {
        cell.selectionStyle = .none
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = .byWordWrapping
        cell.textLabel?.textColor = .white
        cell.tintColor = .white
        cell.textLabel?.textColor = Themes.current.celltext
        cell.detailTextLabel?.textColor = Themes.current.celltext
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        if item.Category == "Personal" {
            cell.backgroundColor = UIColor.orangeTheme
            cell.detailTextLabel?.text = (cellFields[0] + ": " + item.Location)
        }
        if item.Category == "Life" {
            cell.backgroundColor = UIColor.greenTheme
            cell.detailTextLabel?.text = (cellFields[1] + ": " + item.Occurrence)
        }
        if item.Category == "Life" && item.Occurrence == "Yearly" {
            cell.backgroundColor = UIColor.greenTheme
            cell.detailTextLabel?.text = (cellFields[2] + ": " + item.DueDate)
        }
        if item.Category == "Group" {
            cell.backgroundColor = UIColor.blueTheme
            cell.detailTextLabel?.text = (cellFields[3] + ": " + item.User)
        }
        cell.textLabel?.text = item.Name
        cell.isUserInteractionEnabled = false
    }
    
    //MARK: Adds the cells to the views table view. This will also use the above function to theme the cell
    func addTableCell(_ tableView: UITableView, _ indexPath: IndexPath, _ cellFields:[String], items: Results<OddJobItem>) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cellSetup(cell, item, Constants.cellFields)
        return cell
    }
}

extension UITableView {
    func addTableView(_ tableView: UITableView, _ view: UIView) {
        tableView.backgroundColor = Themes.current.background
        tableView.frame = view.frame
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.addSubview(tableView)
    }
}
