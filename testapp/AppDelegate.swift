//
//  AppDelegate.swift
//  testapp
//
//  Created by Vlad Suhomlinov on 29.03.2020.
//  Copyright © 2020 touchin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseConfigurator.configure()
        
        return true
    }
}

