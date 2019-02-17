//
//  TabBarController.swift
//  BerkeleyCloud
//
//  Created by Jia Rui Shan on 2019/2/11.
//  Copyright © 2019 UC Berkeley. All rights reserved.
//

import UIKit
import NMSSH

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIsUserRegistered()
        
        view.backgroundColor = UIColor.white
        initializeTabs()
    }
    
    /** Attempts to connect to the server. If user credentials are not specified, request them by bringing up the set up view. */
    func checkIsUserRegistered() {
        // print("decrypted: " + "123".decrypted(key: "test"))
        // print("encrypted: " + "123".encrypted(key: "test"))
        let d = UserDefaults.standard
        if let username = d.string(forKey: "Username") {
            let password = d.string(forKey: "Password")?.decrypted(key: passphrase) ?? ""
        }
        
    }
    
    func initializeTabs() {
        let myCloud = MyCloudViewController()
        myCloud.tabBarItem = UITabBarItem(title: "My Cloud", image:#imageLiteral(resourceName: "cloud_solid"), tag: 0)
        let localDir = LocalDirectory()
        localDir.isRoot = true
        localDir.tabBarItem = UITabBarItem(title: "Local Directory", image:#imageLiteral(resourceName: "local"), tag: 1)
        viewControllers = [myCloud, localDir].map({ (vc) -> UINavigationController in
            let nav = UINavigationController(rootViewController: vc)
//            nav.navigationBar.barTintColor = UIColor(white: 0.9, alpha: 1)
//            nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            return nav
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
