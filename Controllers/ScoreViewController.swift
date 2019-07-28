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
class ScoreViewController: UIViewController
{
    let realm: Realm
    var items: Results<ScoreItem>
    let tableView = UITableView()
    var notificationToken: NotificationToken?
    var sorts : Results<ScoreItem>!
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.items = realm.objects(ScoreItem.self).filter("Category contains[c] %@", "Score")
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkingScoreSystem()
        let scores = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateScore))
        navigationItem.rightBarButtonItems = [scores]
        title = "Odd Job Scores"
        createProgressCircle()
    }
    
    private func beginDownload() {
        shapeLayer.strokeEnd = 0
        print("Beginning Download")
        animateCircle(animationKey: "Personal")
        print("Finished Animating")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    //Progress Bar Functions
    fileprivate func animateCircle(animationKey: String) {
        print("Animating Personal Progress")
        let scoreItem = realm.objects(ScoreItem.self).first
        let points = CGFloat(scoreItem!.Score) / 100
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = 0
        basicAnimation.toValue = points
        basicAnimation.duration = 2.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut);
        shapeLayer.add(basicAnimation, forKey: animationKey)
        shapeLayer.strokeEnd = 0
        pointsLabel.text = "P:\(Int(points * 100))"
        pointsLabel.textColor = UIColor.greenTheme
    }

    //Score System Checks
    fileprivate func checkingScoreSystem() {
        if let scoreItem = realm.objects(ScoreItem.self).first
        {
            print("There is a score object")
            print(realm.objects(ScoreItem.self).count)
            print (scoreItem.Category)
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
    
    @objc func updateScore() {
        print("Updating Scores")
        if let scoreItem = realm.objects(ScoreItem.self).first
        {
        try! realm.write {
            scoreItem.Score += 1
        }
        }
    }
    
    // Create Progress Circles
    
    fileprivate func createProgressCircle() {
        // Track Layer
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        view.addSubview(pointsLabel)
        pointsLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        pointsLabel.center = view.center
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.blueTheme.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        
        // Creating Progress Bar
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.greenTheme.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        beginDownload()
    }
}
