//
//  AppDelegate.swift
//  Supertal Weather
//
//  Created by Aqib Javed on 18/03/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureApp()
        return true
    }
    
    private func configureApp() {
        let homevc = HomeViewController()
        let navigationVC = UINavigationController(rootViewController: homevc)
        guard let window  else { 
            window = UIWindow()
            window?.rootViewController = navigationVC
            window?.makeKeyAndVisible()
            return
        }
        window.rootViewController = navigationVC
        window.makeKeyAndVisible()
    }
}

