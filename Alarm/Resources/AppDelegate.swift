//
//  AppDelegate.swift
//  Alarm
//
//  Created by Steve Lederer on 12/1/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (success, error) in
            if let error = error {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
            }
            if !success {
                print("This App is pretty much worthless unless you grant notificaitons")
            }
        }
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
        }
        
        notificationCenter.delegate = self

        
        
        return true
    }
}
