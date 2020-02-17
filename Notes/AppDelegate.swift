//
//  AppDelegate.swift
//  Notes
//
//  Created by Илья Бочков  on 1/29/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogger()
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        let tableOfNotes = TableOfNotes()
        tableOfNotes.title = "Notes"
        let navigationController = UINavigationController(rootViewController: tableOfNotes)
        tableOfNotes.tabBarItem = UITabBarItem(title: "Notes",
                                                image: UIImage(systemName: "doc"),
                                                selectedImage: nil)
        let tabBarCotroller = UITabBarController()
        tabBarCotroller.viewControllers = [ navigationController ]
        window?.rootViewController = tabBarCotroller
        window?.makeKeyAndVisible()
        return true
    }
    
    private func setupLogger() {
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }

}

