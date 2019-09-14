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
    let categoryLabel: UILabel = {
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
        animateCircle(category: "Life")
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
    
    func addScoreLabel() {
        view.addSubview(scoreLabel)
        scoreLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        scoreLabel.center = view.center
    }
    
    func addLabel(label: UILabel, anchor: Int, width: Int) {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(anchor)).isActive = true
        label.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        label.heightAnchor.constraint(equalToConstant: 300).isActive = true
        label.adjustsFontSizeToFitWidth = true

    }
    
    func setupUserLabels() {
        addLabel(label: userLabel, anchor: 10, width: 300)
        addLabel(label: levelLabel, anchor: 50, width: 300)
        addLabel(label: categoryLabel, anchor: 90, width: 300)
        addLabel(label: totalScoreLabel, anchor: 140, width: 300)
        addScoreLabel()
    }
    
    func addPulsatiingLayer() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
    }
    
    func addTrackLayer() {
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
    }
    
    func addShapeLayer() {
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    func setupCircleLayers() {
        addPulsatiingLayer()
        addTrackLayer()
        addShapeLayer()
    }
    
    func animationSettings(_ animation: CABasicAnimation) {
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
    }
    
    func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animationSettings(animation)
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    func basicAnimationSettings(_ basicAnimation: CABasicAnimation, scoreItem: ScoreItem) {
        basicAnimation.fromValue = CGFloat(scoreItem.Score - 1) / CGFloat(scoreItem.LevelCap)
        basicAnimation.toValue = CGFloat(scoreItem.Score) / CGFloat(scoreItem.LevelCap)
        basicAnimation.duration = 1
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
    }
    
    func animateCircle(category: String) {
        let scoreItem = getScoreItem(realm: realm, category: "Life")
        print("Score Item Animate Circle")
        print(self.scoreItem)
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimationSettings(basicAnimation, scoreItem: scoreItem)
        shapeLayer.add(basicAnimation, forKey: "Life")
        scoreLabel.text = String(scoreItem.Score)
        userLabel.text = UserDefaults.standard.string(forKey: "Name") ?? ""
        levelLabel.text = String("Level: " + String(scoreItem.Level))
        categoryLabel.text = String("Category: " + String(scoreItem.Category))
        totalScoreLabel.text = String("Total Score: " + String(scoreItem.TotalScore))
    }
}
