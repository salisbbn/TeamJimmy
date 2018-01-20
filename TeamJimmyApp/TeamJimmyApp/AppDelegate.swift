//
//  AppDelegate.swift
//  TeamJimmyApp
//
//  Created by Brian Salisbury on 1/19/18.
//  Copyright © 2018 Brian Salisbury. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        SphinxManager.shared.start()
        return true
    }
}

