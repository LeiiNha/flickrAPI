//
//  AppDelegate.swift
//  FlickrAPISample
//
//  Created by Erica Geraldes on 18/07/2019.
//  Copyright © 2019 Erica Geraldes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewModel = MainViewModel(networkManager: NetworkManager())
        let rootViewController = ViewController(viewModel: mainViewModel)
        
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

