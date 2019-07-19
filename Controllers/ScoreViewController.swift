//
//  ScoreViewController.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 15/07/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift
import RSSelectionMenu
class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let realm: Realm
    var items: Results<ScoreItem>
    let tableView = UITableView()
    var notificationToken: NotificationToken?
    var sorts : Results<ScoreItem>!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items = realm.objects(ScoreItem.self).filter("Category contains[c] %@", "Score")
        self.items = realm.objects(ScoreItem.self).sorted(byKeyPath: "Score", ascending: false)
        super.init(nibName: nil, bundle: nil)
}
    fileprivate func checkingScoreSystem() {
        if let scoreItem = realm.objects(ScoreItem.self).first
        {
            print("There is a score object")
            print(realm.objects(ScoreItem.self).count)
            try! realm.write {
                scoreItem.Score += 1
            }
        } else {
            print("No first object!")
            print("Creating scoring object")
            let scoreItem = ScoreItem()
            scoreItem.Name = "Total Score"
            scoreItem.Score = 0
            try! self.realm.write {
                self.realm.add(scoreItem)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkingScoreSystem()
        tableView.backgroundColor = UIColor.navyTheme
        let scores = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateScore))
        navigationItem.rightBarButtonItems = [scores]
        title = "Odd Job Scores"
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = self.view.frame
        notificationToken = items.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        let item = items[indexPath.row]
        cell.textLabel?.text = String(item.Score)
        cell.tintColor = .white
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.backgroundColor = UIColor.orangeTheme
        cell.detailTextLabel?.text = ("Score: " + String(item.Score))
        cell.detailTextLabel?.text = ("Name: " + item.Name)
        cell.accessoryType = UITableViewCell.AccessoryType.detailButton
        return cell
    }
    
    @objc func updateScore() {
        print("Updating Scores")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        print("Score selected: " + item.Name)
    }
}
