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
class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDownloadDelegate
{
    

    let realm: Realm
    var items: Results<ScoreItem>
    let tableView = UITableView()
    var notificationToken: NotificationToken?
    var sorts : Results<ScoreItem>!
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Personal Score"
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
//        tableView.backgroundColor = UIColor.navyTheme
        let scores = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateScore))
        navigationItem.rightBarButtonItems = [scores]
        title = "Odd Job Scores"
//        tableView.dataSource = self
//        tableView.delegate = self
//        view.addSubview(tableView)
//        tableView.frame = self.view.frame
        
        // Track Layer
        let center = view.center
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.blueTheme.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        // Creating Progress Bar
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.greenTheme.cgColor
        
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(shapeLayer)
        beginDownload()

        //animateProgressBar()
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
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
    
    
    
    
    
    
    
    
    private func beginDownload() {
        shapeLayer.strokeEnd = 0
        print("Beginning Download")
        let urlDemo = "https://go.microsoft.com/fwlink/?LinkID=620882"
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        guard let url = URL(string: urlDemo) else {return}
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    fileprivate func animateCircle() {
        //let scoreItem = realm.objects(ScoreItem.self).first
        //print("Current Percentage: " + String((Double(scoreItem!.Score)) / 100))
        print("Animating Progress")
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        //basicAnimation.toValue = CGFloat((Double(scoreItem!.Score)) / 100)
        basicAnimation.duration = 3
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "BASIC")
    }
    
    @objc private func animateProgressBar() {
        //animateCircle()
        beginDownload()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished Downloading")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //print(totalBytesWritten, totalBytesExpectedToWrite)
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))"
            self.percentageLabel.textColor = UIColor.greenTheme
            self.shapeLayer.strokeEnd = percentage
        }
        
        print(percentage)
    }

    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    //FUNCTIONS
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
        if let scoreItem = realm.objects(ScoreItem.self).first
        {
        try! realm.write {
            scoreItem.Score += 1
        }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        print("Score selected: " + item.Name)
    }
}
