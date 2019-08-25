//
//  OddJobTask.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 21/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//


import UIKit

private let reuseIdentifier = "Cell"

enum taskTypes: Int, CaseIterable {
    case Personal
    case Group
    case Life
    case Others
    
    var description: String {
        switch self {
            
        case .Personal:
            return "Personal"
        case .Group:
            return "Group"
        case .Life:
            return "Life"
        case .Others:
            return "Others"
        }
    }
    
    var category: String {
        switch self {
            
        case .Personal:
            return "Personal"
        case .Group:
            return "Group"
        case .Life:
            return "Life"
        case .Others:
            return "Others"
        }
    }
}
let button = UIButton(type: .system)
var lifeCategoryList = ["Health", "Social", "Finance", "Birthday", "Anniversary","Custom"]

class OddJobTaskViewController: UIViewController {
    
    var tableView: UITableView!
    var showMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        applyTheme(tableView, view)
    }
    
    func configureTableView () {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        
        tableView.register(DropDownCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
    }
    
    @objc func handleDropDown() {
        showMenu = !showMenu
        print("Handle Drop Down")
        var indexPaths = [IndexPath]()
        taskTypes.allCases.forEach { (type) in
            print("Type: \(type) Raw Value: \(type.rawValue)")
            let indexPath = IndexPath(row: type.rawValue, section: 0)
            indexPaths.append(indexPath)
        }
        
        if showMenu {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    func buttonViewToggle(toggle: Bool) {
        if toggle {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = false;
                
                //self.view.layoutIfNeeded()
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = true;
                //self.view.layoutIfNeeded()
            }
        }
    }
}

extension OddJobTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showMenu ? taskTypes.allCases.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = lifeCategoryList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        button.setTitle("Select Task Type", for: .normal)
        button.setTitleColor(.white , for: .normal)
        button.titleLabel?.font = UIFont(name: Themes.mainFontName,size: 18)
        button.addTarget(self, action: #selector(handleDropDown), for: .touchUpInside)
        button.backgroundColor = UIColor.greenTheme
        return button
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //guard let task = taskTypes(rawValue: indexPath.row) else { return }
        button.setTitle("\(lifeCategoryList[indexPath.row])", for: .normal)
        tableView.deselectRow(at: indexPath, animated: true)
        //buttonViewToggle(toggle: false)
    }
    
    
}
