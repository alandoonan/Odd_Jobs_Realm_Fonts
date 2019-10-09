//
//  LifeTaskViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 25/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//


import UIKit
import RealmSwift

class LifeTaskViewController: UIViewController{
    var p: Int!
    var hideTextField = [4,5]
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var categoryButtonTitle: UIButton!
    @IBOutlet weak var selectTaskButton: UIButton!
    @IBOutlet weak var selectWhenButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taskNamingTextField: UITextField!
    @IBAction func taskNameEntryTextField(_ sender: Any) {
        
    }
    
    @IBAction func doneTaskButtonPress(_ sender: Any) {
        performSegueToReturnBack()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        p=0
        taskNamingTextField.isHidden = true
        applyThemeView(view)
        selectCategoryButton.titleLabel?.font = UIFont(name: Themes.mainFontName,size: 18)
        selectWhenButton.titleLabel?.font = UIFont(name: Themes.mainFontName,size: 18)
        selectTaskButton.titleLabel?.font = UIFont(name: Themes.mainFontName,size: 18)
        applyTaskTheme(tableView: tableView, selectTaskButton: selectTaskButton, selectCategoryButton: selectCategoryButton, selectWhenButton: selectWhenButton, userLabel: userLabel)
        hideKeyboardWhenTappedAround()
    }

    @IBAction func selectCategoryButtonPress(_ sender: Any) {
        print("Select Category Pressed")
        p = 0
        if hideTextField.contains(p) {
            print("FOUND P")
            taskNamingTextField.isHidden = false
        }
        else {
            taskNamingTextField.isHidden = true
        }
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
        if selectCategoryButton.titleLabel?.text == "Life Category" {
            invalidLifeSelection(selection: "Life Category")
            return
        }
        if categoryButtonTitle.titleLabel?.text == "Health" {
            p=1
            print("Health")
        }
        if categoryButtonTitle.titleLabel?.text == "Social" {
            p=2
            print("Social")
        }
        if categoryButtonTitle.titleLabel?.text == "Finance" {
            p=3
            print("Finance")

        }
        if categoryButtonTitle.titleLabel?.text == "Birthday" {
            p=4
            print("Birthday")

        }
        if categoryButtonTitle.titleLabel?.text == "Anniversary" {
            p=5
            print("Anniversary")

        }
        if categoryButtonTitle.titleLabel?.text == "Custom" {
            p=6
            print("Custom")
        }
        if hideTextField.contains(p) {
            print("FOUND P")
            taskNamingTextField.isHidden = false
        }
        else {
            taskNamingTextField.isHidden = true
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
        if selectTaskButton.titleLabel?.text == "Life Task" {
            invalidLifeSelection(selection: "Life Task")
            return
        }
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
        createLifeTaskOddJob(selectCategoryButton: selectCategoryButton, selectTaskButton: selectTaskButton, selectWhenButton: selectWhenButton)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }
}

extension LifeTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.taskData[p].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Constants.taskData[p][indexPath.row]
        cell.textLabel?.textColor = Themes.current.accent
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont(name: Themes.mainFontName,size: 18)
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
