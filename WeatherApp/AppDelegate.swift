//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by User on 27.06.2023.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: ViewController())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }

}

