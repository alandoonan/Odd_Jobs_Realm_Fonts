//
//  CreateTaskViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 27/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//


import UIKit
import RealmSwift

class CreateTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBOutlet weak var dateTextField: UITextField!
    
    private var datePickerB: UIDatePicker?
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.taskData[7].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.taskData[7][row]
    }
    
    var p: Int!
    @IBOutlet weak var priorityPicker: UIPickerView!
    @IBOutlet weak var priorityLabel: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBAction func doneTaskButtonPress(_ sender: Any) {
        performSegueToReturnBack()
    }
    @IBAction func createTaskButtonPress(_ sender: Any) {
        print("Create Task.")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerB = UIDatePicker()
        datePickerB?.datePickerMode = .date
        dateTextField.inputView = datePickerB
        datePickerB?.addTarget(self, action: #selector(CreateTaskViewController.dateChanged(datePickerB:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateTaskViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        p=0
        //applyThemeView(view)
        userLabel.text = UserDefaults.standard.string(forKey: "Name") ?? ""
        view.backgroundColor = Themes.current.background
        priorityLabel.textColor = Themes.current.accent
        priorityPicker.backgroundColor = Themes.current.background
        priorityPicker.tintColor = Themes.current.accent
        priorityPicker.setValue(Themes.current.accent, forKeyPath: "textColor")
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        
    }
    
    @objc func dateChanged(datePickerB: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        dateTextField.text = dateFormatter.string(from: datePickerB.date)
        view.endEditing(true)
    }
}

