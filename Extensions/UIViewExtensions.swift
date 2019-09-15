//
//  UIViewControllerExtensions.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 10/09/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

//MARK: UIViewController additional functions
extension UIViewController {
    
    //MARK: Sidebar transistion
    func transition() {
        let homeVC:SideBarController = SideBarController()
        present(homeVC, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            print("Return Home Pop")
            nav.popViewController(animated: true)
        } else {
            print("Return Home Dismiss")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func addTableCell(_ tableView: UITableView, _ indexPath: IndexPath, _ cellFields:[String], items: Results<OddJobItem>) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cellSetup(cell, item, Constants.cellFields)
        return cell
    }
    
    func showStoryBoardView(storyBoardID: String) {
        print("Go to Storyboard Button Pressed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyBoardID)
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    func addNavBar(_ leftButtons: [UIBarButtonItem], _ rightButtons: [UIBarButtonItem], scoreCategory: [String]) {
        navigationItem.leftBarButtonItems = leftButtons
        navigationItem.rightBarButtonItems = rightButtons
        navigationItem.title = scoreCategory.joined(separator:" ")
        
    }
    
    func applyTheme(_ tableView: UITableView, _ view: UIView) {
        let textAttributes = [NSAttributedString.Key.foregroundColor:Themes.current.accent]
        view.backgroundColor = Themes.current.background
        tableView.backgroundColor = Themes.current.background
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Themes.current.background
        navigationController?.navigationBar.barTintColor = Themes.current.background
        navigationController?.navigationBar.tintColor = Themes.current.accent
        navigationController?.navigationBar.backgroundColor = Themes.current.background
        navigationController?.navigationBar.titleTextAttributes = textAttributes
//        UITextField.appearance().keyboardAppearance = .dark
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes

    }
    
    func applyThemeView(_ view: UIView) {
        let textAttributes = [NSAttributedString.Key.foregroundColor:Themes.current.accent]
        view.backgroundColor = Themes.current.background
        navigationController?.navigationBar.backgroundColor = Themes.current.background
        navigationController?.navigationBar.barTintColor = Themes.current.background
        navigationController?.navigationBar.tintColor = Themes.current.accent
        navigationController?.navigationBar.titleTextAttributes = textAttributes
//        UITextField.appearance().keyboardAppearance = .dark
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
    }
    
    func logOutUsers() {
        print("Logging out users.")
        for u in SyncUser.all {
            print("Logging out user: " + String(u.value.identity!))
            u.value.logOut()
        }
    }
    
    @objc func logOutButtonPress() {
        let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "Yes, Logout", style: .destructive, handler: {
            alert -> Void in
            SyncUser.current?.logOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: false, completion: nil)
    }
    
    func addSearchBar(scoreCategory: [String], searchBar: UISearchBar) {
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false
        searchBar.placeholder = "Search " + scoreCategory.joined(separator:" ")
    }
    
    func deleteOddJob(_ indexPath: IndexPath, realm: Realm, items: Results<OddJobItem>) {
        let item = items[indexPath.row]
        try! realm.write {
            realm.delete(item)
        }
    }
    
    func addTaskAlert(realm: Realm, scoreCategory: [String]) {
        let alertController = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let oddJobName = alertController.textFields![0] as UITextField
            let oddJobPriority = alertController.textFields![1] as UITextField
            let oddJobOccurrence = alertController.textFields![2] as UITextField
            let item = OddJobItem()
            item.Name = oddJobName.text ?? ""
            item.Priority = oddJobPriority.text ?? ""
            item.Occurrence = oddJobOccurrence.text ?? ""
            item.Category = scoreCategory[0]
            try! realm.write {
                realm.add(item)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        for field in Constants.sortFields {
            alertController.addTextField(configurationHandler: {(oddJobName : UITextField!) -> Void in
                oddJobName.placeholder = field
            })
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func cellSetup(_ cell: UITableViewCell, _ item: OddJobItem, _ cellFields: [String]) {
        cell.selectionStyle = .none
        cell.tintColor = .white
        //cell.layer.cornerRadius = 10
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        cell.selectionStyle = .none
        cell.tintColor = .white
        cell.textLabel?.textColor = Themes.current.celltext
        cell.detailTextLabel?.textColor = Themes.current.celltext
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        if item.Category == "Personal" {
            cell.backgroundColor = UIColor.orangeTheme
            cell.detailTextLabel?.text = (cellFields[0] + ": " + item.Location)
        }
        if item.Category == "Life" {
            cell.backgroundColor = UIColor.greenTheme
            cell.detailTextLabel?.text = (cellFields[1] + ": " + item.Occurrence)
        }
        if item.Category == "Group" {
            cell.backgroundColor = UIColor.blueTheme
            cell.detailTextLabel?.text = (cellFields[2] + ": " + item.DueDate)
        }
        cell.textLabel?.text = item.Name
        
        cell.textLabel!.font = UIFont(name: Themes.mainFontName,size: 18)
        cell.isUserInteractionEnabled = false
    }
    
    func findOddJobItemByName(_ Name: String, realm: Realm) -> Results<OddJobItem> {
        let predicate = NSPredicate(format: "Name = %@", Name)
        return realm.objects(OddJobItem.self).filter(predicate)
    }
    
    func findColourByName(_ Name: String, realm: Realm) -> Results<ThemeItem>
    {
        let predicate = NSPredicate(format: "name = %@", Name)
        return realm.objects(ThemeItem.self).filter(predicate)
    }
    
    @objc func mapTasks() {
        print("Search Button Pressed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MapTasksViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
    func applyTaskTheme(tableView: UITableView, selectTaskButton: UIButton, selectCategoryButton: UIButton, selectWhenButton: UIButton, userLabel: UILabel) {
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        selectTaskButton.backgroundColor = Themes.current.accent
        selectCategoryButton.backgroundColor = Themes.current.accent
        selectWhenButton.backgroundColor = Themes.current.accent
        selectTaskButton.titleLabel?.textColor = Themes.current.background
        selectTaskButton.setTitleColor(Themes.current.background, for: .normal)
        selectCategoryButton.setTitleColor(Themes.current.background, for: .normal)
        selectWhenButton.setTitleColor(Themes.current.background, for: .normal)
        userLabel.text = UserDefaults.standard.string(forKey: "Name") ?? ""
        userLabel.textColor = Themes.current.accent
        let navigationAppearance = UINavigationBar.appearance()
        navigationAppearance.tintColor = Themes.current.accent
        navigationAppearance.barTintColor = Themes.current.background
        navigationAppearance.backgroundColor = Themes.current.background
        navigationAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
}
