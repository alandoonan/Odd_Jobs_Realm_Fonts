//
//  ScoreExtensions.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 12/09/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import RealmSwift

extension UIViewController {
    
    // MARK: Creating Score Item
    func checkingScoreSystem() {
        var scoreItem: Results<ScoreItem>
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        let realm = try! Realm(configuration: config!)
        scoreItem = realm.objects(ScoreItem.self).filter("Category contains[c] %@", "Life")
        print("Checking Scoring System.")
        print(scoreItem)
        if Int(realm.objects(ScoreItem.self).count) == 0 {
            for field in Constants.listTypes {
                let newScore = ScoreItem()
                newScore.Name = field
                newScore.Category = field
                newScore.User = UserDefaults.standard.string(forKey: "Name") ?? ""
                try! realm.write {
                    realm.add(newScore)
                    print("Creating score for list: " + String(newScore.Category))
                }
            }
        }
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
        let lifeTotalScore = getScoreItem(realm: realm, category: Constants.lifeScoreCategory[0])
        if scoreItem.Score == scoreItem.LevelCap {
            try! realm.write {
                scoreItem.Score = 0
                scoreItem.Level += value
                lifeTotalScore.TotalScore += value
            }
        }
        else {
            try! realm.write {
                scoreItem.Score += value
                lifeTotalScore.TotalScore += value
            }
        }
    }
}
