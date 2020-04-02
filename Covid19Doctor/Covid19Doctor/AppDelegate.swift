//
//  AppDelegate.swift
//  Covid19Doctor
//
//  Created by Francesco Cosentino on 11/03/2020.
//  Copyright © 2020 Francesco Cosentino. All rights reserved.
//

import UIKit
import Toast_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureUI()
        runUI()
        return true
    }
    
    func runUI() {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let root: UIViewController
        if Database.shared.isActivated() {
            let vc = UIStoryboard.getViewController(id: "Activity") as! ActivityViewController
            root = UINavigationController(rootViewController: vc)
        } else {
            let vc = UIStoryboard.getViewController(id: "Introduction")
            root = UINavigationController(rootViewController: vc)
        }

        self.window?.rootViewController = root //UIStoryboard.getViewController(id: "PatientViewController")
        self.window?.makeKeyAndVisible()
    }
    
    func configureUI() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = .mainTheme
        
        var style = ToastStyle()
        style.backgroundColor = UIColor(white: 0.35, alpha: 0.95)
        style.activityBackgroundColor = style.backgroundColor
        style.titleFont = style.titleFont.withSize(20)
        style.messageFont = style.titleFont
        style.horizontalPadding = 25
        style.verticalPadding = 25
        style.cornerRadius = 30
        ToastManager.shared.style = style
        ToastManager.shared.duration = 3.5
        ToastManager.shared.isTapToDismissEnabled = false
        ToastManager.shared.position = .center
    }
}
