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
import RealmSearchViewController


class CreateTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    var datePicker: UIDatePicker?
    var priorityPicker: UIPickerView?
    var categoryPicker: UIPickerView?
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var longitude = 0.0
    var latitude = 0.0
    var p : Int?
    var realm: Realm!
    var items: Results<UserItem>?
    var notificationToken: NotificationToken?
    var sharedUserName = ""
    var sharedUserID = ""

    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var usersSearchBar: UISearchBar!
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
        createOddJobTask(latitude: latitude, longitude: longitude, taskNameTextField: taskNameTextField,
                         dateTextField: dateTextField, priorityTextField: priorityTextField, categoryTextField: categoryTextField, locationSearchBar: locationSearchBar, userSearchBar: usersSearchBar, sharedUserID: sharedUserID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        applyThemeView(view)
    }
    
    func loadItems() {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_USERS_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items = realm.objects(UserItem.self).filter("Category contains[c] %@", "User")
        //self.tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        p = 0
        view.backgroundColor = Themes.current.background
        userLabel.text = UserDefaults.standard.string(forKey: "Name") ?? ""
        searchLocationsResults.separatorStyle = .none
        applyTheme(searchLocationsResults,view)
        setupDatePicker()
        setupPriorityPicker()
        setupCategoryPicker()
        searchCompleter.delegate = self
        self.loadItems()
    }
    
    func addNotificationToken() {
        notificationToken = self.items!.observe { [weak self] (changes) in
            guard let tableView = self?.searchLocationsResults else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
    
    func setupPriorityPicker() {
        priorityPicker = UIPickerView()
        priorityPicker?.delegate = self
        priorityPicker?.dataSource = self
        priorityTextField.inputView = priorityPicker
        priorityPicker?.backgroundColor = Themes.current.accent
    }
    
    func setupCategoryPicker() {
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
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}

extension CreateTaskViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchLocationsResults.isHidden = true
        if searchBar == self.locationSearchBar {
            print("Locations")
            print("CHANGING TEXT IN LOCATION SEARCH BAR")
            print(p!)
            p = 0
            searchCompleter.queryFragment = searchText
            searchLocationsResults.isHidden = false
        } else if searchBar == self.usersSearchBar{
            print("Users")
            print("CHANGING TEXT IN USERS SEARCH BAR")
            p = 1
            searchLocationsResults.isHidden = false
            print(p!)
            print("typing in search bar: term = \(searchText)")
            if searchText != "" {
                let predicate = NSPredicate(format:"(Name CONTAINS[c] %@) AND Category in %@", searchText, ["User"])
                self.items = realm.objects(UserItem.self).filter(predicate)
                searchLocationsResults.reloadData()
            } else {
                searchLocationsResults.isHidden = true
                self.items = realm.objects(UserItem.self).filter("Category in %@", ["User"])
                searchLocationsResults.reloadData()
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchLocationsResults.isHidden = true
    }
        
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar == self.locationSearchBar {
            p = 0
        }
        else {
            p = 1
        }
        searchLocationsResults.isHidden = true
        searchLocationsResults.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchLocationsResults.isHidden = true
    }
}

extension CreateTaskViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchLocationsResults.reloadData()
    }
}

extension CreateTaskViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if p == 0 {
            return searchResults.count
        }
        else {
            return self.items!.count
        }
    }
    
    func addTableCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let item = self.items![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "userCell")
        cell.selectionStyle = .none
        cell.textLabel?.text = item.Name
        cell.tintColor = .white
        cell.textLabel?.textColor = Themes.current.accent
        cell.detailTextLabel?.textColor = .white
        cell.backgroundColor = Themes.current.background
        cell.selectionStyle = .none
        cell.detailTextLabel?.text = ("Name: " + item.Name)
        cell.detailTextLabel?.text = (item.UserID)
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        return cell
    }
    
    func addLocationCell(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = searchLocationsResults.dequeueReusableCell(withIdentifier: "locationCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "locationCell")
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if p == 0 {
            return addLocationCell(indexPath, searchLocationsResults)
    }
        else if p == 1{
            return addTableCell(searchLocationsResults, indexPath)
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            return cell
        }
    }
}

extension CreateTaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if p == 0 {
            let completion = searchResults[indexPath.row]
            let searchRequest = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                let coordinate = response?.mapItems[0].placemark.coordinate
                let itemAddress = String(response?.mapItems[0].placemark.subThoroughfare ?? "") + " " + String(response?.mapItems[0].placemark.thoroughfare ?? "")
                (self.latitude, self.longitude) = (coordinate?.latitude, coordinate?.longitude) as! (Double, Double)
                self.locationSearchBar.text = String(itemAddress)
                self.searchLocationsResults.isHidden = true
        }
    }
        else if p == 1 {
            searchLocationsResults.reloadData()
            let cell = searchLocationsResults.dequeueReusableCell(withIdentifier: "userCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "userCell")
            usersSearchBar.text = cell.textLabel!.text
            self.sharedUserName = cell.textLabel!.text!
            self.sharedUserID = cell.detailTextLabel!.text!
            print(cell)
            print(self.sharedUserName)
            print(self.sharedUserID)
        }
    }
}
