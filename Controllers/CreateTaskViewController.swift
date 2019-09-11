//
//  CreateTaskViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 27/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//


import UIKit
import RealmSwift
import MapKit

class CreateTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    var datePicker: UIDatePicker?
    var priorityPicker: UIPickerView?
    var categoryPicker: UIPickerView?
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var longitude = 0.0
    var latitude = 0.0
    
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var searchLocationsResults: UITableView!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var priorityTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var taskButtonText: UIButton!
    @IBAction func doneTaskButtonPress(_ sender: Any) {
        print("Done button tapped.")
        performSegueToReturnBack()
    }
    @IBAction func createTaskButtonPress(_ sender: Any) {
        print("Create Task.")
        print(self.latitude,self.longitude)
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        let realm = try! Realm(configuration: config!)
        let oddJobName = taskNameTextField.text
        let oddJobDate = dateTextField.text
        let oddJobPriority = priorityTextField.text
        let oddJobCategory = categoryTextField.text
        let oddJobLocationName = locationSearchBar.text
        let item = OddJobItem()
        item.Name = oddJobName!
        item.DueDate = oddJobDate!
        item.Priority = oddJobPriority!
        item.Category = oddJobCategory!
        item.Location = oddJobLocationName!
        item.Latitude = self.latitude
        item.Longitude = self.longitude
        try! realm.write {
            realm.add(item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Themes.current.background
        userLabel.text = UserDefaults.standard.string(forKey: "Name") ?? ""
        searchLocationsResults.separatorStyle = .none
        applyTheme(searchLocationsResults,view)
        let attributes = [NSAttributedString.Key.foregroundColor: Themes.current.accent]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
        setupDatePicker()
        setupPriorityPicker()
        setupCategoryPicker()
        searchCompleter.delegate = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == priorityPicker {
            return Constants.taskPriority.count
        }
        else if pickerView == categoryPicker {
            return Constants.createTaskTypes.count
        }
        return 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == priorityPicker {
            return Constants.taskPriority[row]
        }
        else if pickerView == categoryPicker {
            taskButtonText.titleLabel?.adjustsFontSizeToFitWidth = true
            taskButtonText.setTitle("Create " + String(Constants.createTaskTypes[row]) + " Task",for: .normal)
            return Constants.createTaskTypes[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == priorityPicker {
            priorityTextField.text = Constants.taskPriority[row]
            self.view.endEditing(false)
        }
        else if pickerView == categoryPicker {
            categoryTextField.text = Constants.createTaskTypes[row]
            self.view.endEditing(false)
        }
    }
    
    fileprivate func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(CreateTaskViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePicker?.setValue(Themes.current.background, forKey: "textColor")
        datePicker?.backgroundColor = Themes.current.accent
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateTaskViewController.viewTapped(gestureRecognizer:)))
//        view.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func setupPriorityPicker() {
        priorityPicker = UIPickerView()
        priorityPicker?.delegate = self
        priorityPicker?.dataSource = self
        priorityTextField.inputView = priorityPicker
        priorityPicker?.backgroundColor = Themes.current.accent
    }
    
    fileprivate func setupCategoryPicker() {
        categoryPicker = UIPickerView()
        categoryPicker?.delegate = self
        categoryPicker?.dataSource = self
        categoryTextField.inputView = categoryPicker
        categoryPicker?.backgroundColor = Themes.current.accent
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}

extension CreateTaskViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        searchLocationsResults.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchLocationsResults.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchLocationsResults.isHidden = false
        
    }
}

extension CreateTaskViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        //print(searchResults)
        searchLocationsResults.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension CreateTaskViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = Themes.current.background
        cell.selectionStyle = .none
        cell.tintColor = .white
        cell.textLabel?.textColor = Themes.current.accent
        cell.detailTextLabel?.textColor = .white
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension CreateTaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            let itemAddress = String(response?.mapItems[0].placemark.subThoroughfare ?? "") + " " + String(response?.mapItems[0].placemark.thoroughfare ?? "")
            (self.latitude, self.longitude) = (coordinate?.latitude, coordinate?.longitude) as! (Double, Double)
            self.locationSearchBar.text = String(itemAddress)
            self.searchLocationsResults.isHidden = true
            self.hideKeyboardWhenTappedAround()

        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
