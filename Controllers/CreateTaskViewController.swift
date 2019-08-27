//
//  CreateTaskViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 27/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//


import UIKit
import RealmSwift

class CreateTaskViewController: UIViewController{
    var p: Int!

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var categoryButtonTitle: UIButton!
    @IBOutlet weak var selectTaskButton: UIButton!
    @IBOutlet weak var selectWhenButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func doneTaskButtonPress(_ sender: Any) {
        performSegueToReturnBack()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        p=0
        applyThemeView(view)
        applyTaskTheme(tableView: tableView, selectTaskButton: selectTaskButton, selectCategoryButton: selectCategoryButton, selectWhenButton: selectWhenButton, userLabel: userLabel)
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
        if categoryButtonTitle.titleLabel?.text == "Health" {
            p=1
        }
        if categoryButtonTitle.titleLabel?.text == "Social" {
            p=2
        }
        if categoryButtonTitle.titleLabel?.text == "Finance" {
            p=3
        }
        if categoryButtonTitle.titleLabel?.text == "Birthday" {
            p=4
        }
        if categoryButtonTitle.titleLabel?.text == "Anniversary" {
            p=5
        }
        if categoryButtonTitle.titleLabel?.text == "Custom" {
            p=6
        }
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
        p = 7
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

extension CreateTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.taskData[p].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Constants.taskData[p][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if p == 0 {
            categoryButtonTitle.setTitle("\(Constants.taskData[p][indexPath.row])", for: .normal)
        }
        if [1,2,3,4,5,6].contains(p) {
            selectTaskButton.setTitle("\(Constants.taskData[p][indexPath.row])", for: .normal)
        }
        if p == 7 {
            selectWhenButton.setTitle("\(Constants.taskData[p][indexPath.row])", for: .normal)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        buttonViewToggle(toggle: false)
    }
}
