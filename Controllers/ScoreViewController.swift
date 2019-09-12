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

class ScoreViewController: UIViewController {
    
    //Realm Items
    let realm: Realm
    var scoreItem: Results<ScoreItem>
    var shapeLayer = CAShapeLayer()
    var pulsatingLayer = CAShapeLayer()
    let userDetails = LoginViewController()
    var scoreActive = true
    let levelLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    let totalScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    let userLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        self.scoreItem = realm.objects(ScoreItem.self).filter("Category contains[c] %@", "Life")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        //let postition = CGPoint(x: 100,y: 100)
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 50, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = view.center
        return layer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sideBar = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.automatic), style: .plain, target: self, action: #selector(handleDismiss))
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutButtonPress))
        addNavBar([sideBar], [logout],scoreCategory: [""])
        navigationController?.navigationBar.tintColor = Themes.current.accent
        navigationItem.title = "Score"
        checkingScoreSystem(realm: realm)
        setupCircleLayers()
        animateCircle()
        setupUserLabels()
        applyThemeView(view)
        //autoRefreshScores(scoreCategory: "Personal")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        applyThemeView(view)
    }
    
    fileprivate func addScoreLabel() {
        view.addSubview(scoreLabel)
        scoreLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        scoreLabel.center = view.center
    }
    
    fileprivate func addTotalScoreLabel() {
        view.addSubview(totalScoreLabel)
        totalScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        totalScoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalScoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        totalScoreLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        totalScoreLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        totalScoreLabel.adjustsFontSizeToFitWidth = true
    }
    
    fileprivate func addUserLabel() {
        view.addSubview(userLabel)
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        userLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    fileprivate func addLevelLabel() {
        view.addSubview(levelLabel)
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        levelLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        levelLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        levelLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func setupUserLabels() {
        addScoreLabel()
        addUserLabel()
        addLevelLabel()
        addTotalScoreLabel()
    }
    
    fileprivate func addPulsatiingLayer() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
    }
    
    fileprivate func addTrackLayer() {
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
    }
    
    fileprivate func addShapeLayer() {
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    private func setupCircleLayers() {
        addPulsatiingLayer()
        addTrackLayer()
        addShapeLayer()
    }
    
    fileprivate func animationSettings(_ animation: CABasicAnimation) {
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animationSettings(animation)
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    fileprivate func basicAnimationSettings(_ basicAnimation: CABasicAnimation, _ scoreItem: ScoreItem?) {
        basicAnimation.fromValue = CGFloat(scoreItem!.Score - 1) / CGFloat(scoreItem!.LevelCap)
        basicAnimation.toValue = CGFloat(scoreItem!.Score) / CGFloat(scoreItem!.LevelCap)
        basicAnimation.duration = 1
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
    }
    
    func animateCircle() {
        let scoreItem = realm.objects(ScoreItem.self).first
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimationSettings(basicAnimation, scoreItem)
        shapeLayer.add(basicAnimation, forKey: "Life")
        scoreLabel.text = String(scoreItem!.Score)
        userLabel.text = UserDefaults.standard.string(forKey: "Name") ?? ""
        levelLabel.text = String("Level: " + String(scoreItem!.Level))
        totalScoreLabel.text = String("Total Score: " + String(scoreItem!.TotalScore))
    }
}
