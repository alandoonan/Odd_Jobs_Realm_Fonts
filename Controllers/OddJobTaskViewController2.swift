//
//  OddJobTaskViewController2.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 25/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//


import UIKit
import RealmSwift

class OddJobTaskViewController2: UIViewController{
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    var categoryList = ["Health", "Social", "Finance", "Birthday", "Anniversary","Custom"]
    var taskList = ["No Smoking", "Drink Water"]
    var whenList = ["Daily","Weekly","Monthly","Years"]
    @IBOutlet weak var categoryButtonTitle: UIButton!
    @IBOutlet weak var selectTaskButton: UIButton!
    @IBOutlet weak var selectWhenButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyThemeView(view)
        tableView.isHidden = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        selectTaskButton.backgroundColor = Themes.current.accent
        selectCategoryButton.backgroundColor = Themes.current.accent
        selectWhenButton.backgroundColor = Themes.current.accent
        userLabel.text = UserDefaults.standard.string(forKey: "Name") ?? ""
    }

    @IBAction func selectCategoryButtonPress(_ sender: Any) {
        if tableView.isHidden {
            buttonViewToggle(toggle: true)
        }
        else {
            buttonViewToggle(toggle: false)
        }
    }
    
    @IBAction func selectTaskButtonPress(_ sender: Any) {
        if tableView.isHidden {
            buttonViewToggle(toggle: true)
        }
        else {
            buttonViewToggle(toggle: false)
        }
    }
    @IBAction func selectWhenButtonPressed(_ sender: Any) {
        if tableView.isHidden {
            buttonViewToggle(toggle: true)
        }
        else {
            buttonViewToggle(toggle: false)
        }
    }
    
    
    @IBAction func createTaskButtonPress(_ sender: Any) {
        print("Create Task.")
    }
    
    func buttonViewToggle(toggle: Bool) {
        if toggle {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = false;
                self.view.layoutIfNeeded()
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = true;
                self.view.layoutIfNeeded()
            }
        }
    }
}
extension OddJobTaskViewController2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row] + " " + String(indexPath.section)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryButtonTitle.setTitle("\(categoryList[indexPath.row])", for: .normal)
        tableView.deselectRow(at: indexPath, animated: true)
        buttonViewToggle(toggle: false)
    }
}
