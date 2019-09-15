//
//  ScoreExtensions.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 12/09/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

extension UIViewController {
    
    // MARK: Creating Score Item
    func checkingScoreSystem(realm: Realm) {
        print("Checking Scoring System.")
        if realm.objects(ScoreItem.self).count != 0
        {
            print("Score already exists.")
        } else {
            for field in Constants.listTypes {
                let newScore = ScoreItem()
                newScore.Name = field
                newScore.Category = field
                try! realm.write {
                    realm.add(newScore)
                    print("Creating score for list: " + String(newScore.Category))
                }
            }
        }
    }
    // MARK: Task Completion Actions
    func doneOddJob(_ indexPath: IndexPath, value: Int, realm: Realm, items: Results<OddJobItem>, themes: Results<ThemeItem>, scoreItem: Results<ScoreItem>, tableView: UITableView) {
        let item = items[indexPath.row]
        let score = getScore(realm: realm, category: item.Category)
        let level = getLevel(realm: realm, category: item.Category)
        if (score == 0) && (level == 0)  && (value < 0) {
            print("We cant decrease the score.")
        }
        else {
        updateScore(realm: realm, value: value, category: item.Category)
        }
        try! realm.write {
            item.IsDone = !item.IsDone
        }
        addThemes(realm: realm, themes: themes, scoreItem: scoreItem, tableView: tableView)
        print("HERE NOW")
        let unlocked = checkThemeUnlocked(realm: realm, themes: themes, scoreItem: scoreItem, tableView: tableView)
        print(unlocked)
        
    }
    
    // MARK: Retrieve Levels, Scores & Score Item
    func getScore(realm: Realm, category: String) -> Int{
        print("Getting Score")
        let score = realm.objects(ScoreItem.self).filter("Category contains [c] %@", category)
        print(score)
        return score.first!.Score
    }
    func getLevel(realm: Realm, category: String) -> Int{
        print("Getting Level")
        let level = realm.objects(ScoreItem.self).filter("Category contains [c] %@", category)
        print(level)
        return level.first!.Level
    }
    func getScoreItem(realm: Realm, category: String) -> ScoreItem {
        let scoreItem = realm.objects(ScoreItem.self).filter("Category contains [c] %@", category)
        return scoreItem.first!
    }
    
    // MARK: Update Level & Score
    func updateScore(realm: Realm, value: Int, category: String) {
        print("Checking Score & Level")
        let scoreItem = getScoreItem(realm: realm, category: category)
        if scoreItem.Score == scoreItem.LevelCap {
            try! realm.write {
                scoreItem.Score = 0
                scoreItem.Level += value
                scoreItem.TotalScore += value
            }
        }
        else {
            try! realm.write {
                scoreItem.Score += value
                scoreItem.TotalScore += value
            }
        }
    }
    
}
