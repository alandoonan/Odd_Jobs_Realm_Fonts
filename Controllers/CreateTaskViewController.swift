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


class CreateTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var datePicker: UIDatePicker?
    private var priorityPicker: UIPickerView?
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var searchLocationsResults: UITableView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var priorityLabel: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    @IBAction func doneTaskButtonPress(_ sender: Any) {
        performSegueToReturnBack()
    }
    @IBAction func createTaskButtonPress(_ sender: Any) {
        print("Create Task.")
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.taskPriority.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.taskPriority[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priorityLabel.text = Constants.taskPriority[row]
        self.view.endEditing(false)
    }

    fileprivate func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(CreateTaskViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePicker?.setValue(Themes.current.background, forKey: "textColor")
        datePicker?.backgroundColor = Themes.current.accent
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateTaskViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        view.backgroundColor = Themes.current.background
        userLabel.text = UserDefaults.standard.string(forKey: "Name") ?? ""
        searchLocationsResults.separatorStyle = .none
        applyTheme(searchLocationsResults,view)
        setupDatePicker()
        setupPriorityPicker()
        
    }
    
    fileprivate func setupPriorityPicker() {
        priorityPicker = UIPickerView()
        priorityPicker?.delegate = self
        priorityPicker?.dataSource = self
        priorityLabel.inputView = priorityPicker
        priorityPicker?.backgroundColor = Themes.current.accent
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

func getCoordinates(address: String) {
    let geoCoder = CLGeocoder()
    geoCoder.geocodeAddressString(address) { (placemarks, error) in
        guard
            let placemarks = placemarks,
            let location = placemarks.first?.location
            else {
                return
        }
        print("Printing Coords")
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
    }
}

extension CreateTaskViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
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
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = Themes.current.background
        cell.selectionStyle = .none
        cell.tintColor = .white
        cell.textLabel?.textColor = Themes.current.accent
        cell.detailTextLabel?.textColor = .white
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        //cell.accessoryType = searchResult. ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        
        return cell
    }
}

extension CreateTaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("SELECTING ROW")
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            let itemAddress = String(response?.mapItems[0].placemark.subThoroughfare ?? "") + " " + String(response?.mapItems[0].placemark.thoroughfare ?? "")
            print(String(itemAddress))
            print(String(describing: coordinate))
        }
    }
}

