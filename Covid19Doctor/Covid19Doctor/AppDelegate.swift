//
//  AppDelegate.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 11/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //runUI()
        return true
    }
    
    func runUI() {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let id = Database.shared.isAccountActivated() ? "Activity" : "Introduction"
        let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id)

        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
}
