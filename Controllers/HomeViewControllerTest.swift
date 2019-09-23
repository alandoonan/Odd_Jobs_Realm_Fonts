//
//  HomeViewControllerTest.swift
//  Odd_Jobs_Realm
//
//  Created by Alan Doonan on 13/08/2019.
//  Copyright © 2019 Alan Doonan. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewControllerTest: UIViewController {
    
    var realm: Realm
    var notificationToken: NotificationToken?
    var delegate: HomeControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes.current.preferredStatusBarStyle
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureNavigationBar()
        applyThemeView(view)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        applyThemeView(view)
        //let newUser = createProfile()
//        let permission = SyncPermission(realmPath: "/5453f03aef4409979f41df600956ede3/Oddjobs", identity: "*", accessLevel: .write)
//        print(permission)
//        print("Applying Permissions")
//
//
//        SyncUser.current?.apply(permission) { error in
//          if let error = error {
//            // handle error
//            print(error)
//            return
//          }
//            print("Permission applied")
//          // permission was successfully applied
//        }
    }
    
    func sharedRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = (SyncUser.current?.configuration(realmURL: Constants.ODDJOBS_REALM_USERS_URL, fullSynchronization: true))!
        return config
    }
    
    func createProfile() -> UserItem? {
        let commonRealm =  try! Realm(configuration: sharedRealmConfig(user:SyncUser.current!))
        var profileRecord = commonRealm.objects(UserItem.self).filter(NSPredicate(format: "UserID = %@", SyncUser.current!.identity!)).first
        if profileRecord == nil {
            try! commonRealm.write {
                profileRecord = commonRealm.create(UserItem.self, value:["UserID": SyncUser.current!.identity!, "Name": "Test",  "Category": "Test"])
                commonRealm.add(profileRecord!)
            }
        }
        return profileRecord
    }
        
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
        print("Sidebar button pressed")
    }
    
    fileprivate func createHomeBackGround() {
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "sidebar.png")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = Themes.current.background
        navigationController?.navigationBar.tintColor = Themes.current.accent
        navigationController?.view.backgroundColor = Themes.current.background
        navigationItem.title = "Odd Jobs"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.automatic), style: .plain, target: self, action: #selector(handleMenuToggle))
        createHomeBackGround()
    }
    
}
