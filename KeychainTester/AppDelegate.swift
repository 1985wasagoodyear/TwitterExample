//
//  AppDelegate.swift
//  Created 4/20/20
//  Using Swift 5.0
// 
//  Copyright © 2020 Kevin Yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TokenTestViewController()
        window?.makeKeyAndVisible()
        return true
    }

}
