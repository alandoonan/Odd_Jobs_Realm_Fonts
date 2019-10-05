//
//  Trash.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 08/09/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

//MARK: Sorting Functions & Menu
//    func rssSelectionMenuSort() {
//        var selectedNames: [String] = []
//        let menu = RSSelectionMenu(dataSource: Constants.sortFields) { (cell, name, indexPath) in
//            cell.textLabel?.text = name
//            cell.textLabel?.textColor = .white
//            cell.backgroundColor = Themes.current.background
//        }
//        menu.setSelectedItems(items: selectedNames) { (name, index, selected, selectedItems) in
//            selectedNames = selectedItems
//            self.sortOddJobs(sort: String(selectedItems[0]))
//        }
//        menu.show(style: .push, from: self)
//    }
//    @objc func selectSortField() {
//        print("Sort Button Pressed")
//        rssSelectionMenuSort()
//    }
//    @objc func sortOddJobs(sort:String) {
//        self.items = self.items.sorted(byKeyPath: sort, ascending: true)
//        notificationToken = items.observe { [weak self] (changes) in
//            guard let tableView = self?.tableView else { return }
//            switch changes {
//            case .initial:
//                tableView.reloadData()
//            case .update(_, let deletions, let insertions, let modifications):
//                tableView.beginUpdates()
//                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
//                                     with: .automatic)
//                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
//                                     with: .automatic)
//                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
//                                     with: .automatic)
//                tableView.endUpdates()
//            case .error(let error):
//                fatalError("\(error)")
//            }
//        }
//    }
