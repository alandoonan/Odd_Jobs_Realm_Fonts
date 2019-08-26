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
    
    var p: Int!
    
    var taskGroups = ["Health": ["No Smoking","Drink Water","Go For A Walk","Eat A Healthy Meal"], "Social": ["Call A Friend","Go Visit A Family Member","Do Something Nice For Somebody"], "Finance": ["Save Small Sum Of Money","Pay A Bill"], "Birthday": ["Partners Birthday","Childs Birthday","Mothers Birthday","Fathers Birthday"], "Anniversary": ["Wedding","Couple","Passed Family Member or Friend","Parents Wedding"],"Custom": ["Test"]]
    
    var taskData = [["Health", "Social", "Finance", "Birthday", "Anniversary","Custom"],["No Smoking", "Drink Water"],["Daily","Weekly","Monthly","Yearly"]]
//    var taskList = ["No Smoking", "Drink Water"]
//    var whenList = ["Daily","Weekly","Monthly","Years"]
    @IBOutlet weak var categoryButtonTitle: UIButton!
    @IBOutlet weak var selectTaskButton: UIButton!
    @IBOutlet weak var selectWhenButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        p=0
        applyThemeView(view)
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        selectTaskButton.backgroundColor = Themes.current.accent
        selectCategoryButton.backgroundColor = Themes.current.accent
        selectWhenButton.backgroundColor = Themes.current.accent
        userLabel.text = UserDefaults.standard.string(forKey: "Name") ?? ""
    }

    @IBAction func selectCategoryButtonPress(_ sender: Any) {
        print("Select Category Pressed")
        p = 0
        tableView.reloadData()
        if tableView.isHidden {
            buttonViewToggle(toggle: true)
        }
        else {
            buttonViewToggle(toggle: false)
        }
    }
    
    @IBAction func selectTaskButtonPress(_ sender: Any) {
        print("Select Task Pressed")
        p=1
        tableView.reloadData()
        if tableView.isHidden {
            buttonViewToggle(toggle: true)
        }
        else {
            buttonViewToggle(toggle: false)
        }

    }
    @IBAction func selectWhenButtonPressed(_ sender: Any) {
        print("Select When Pressed")
        p=2
        tableView.reloadData()
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
        print(taskData[p].count)
        return taskData[p].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskData[p][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if p == 0 {
            categoryButtonTitle.setTitle("\(taskData[p][indexPath.row])", for: .normal)
        }
        if p == 1 {
            selectTaskButton.setTitle("\(taskData[p][indexPath.row])", for: .normal)
        }
        if p == 2 {
            selectWhenButton.setTitle("\(taskData[p][indexPath.row])", for: .normal)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        buttonViewToggle(toggle: false)
    }
}
