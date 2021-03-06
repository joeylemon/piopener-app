//
//  AppDelegate.swift
//  Garage Door
//
//  Created by Joey Lemon on 6/17/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    let notifications = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        notifications.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        // Monitor the region surrounding the apartment
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            Utils.monitorRegion(location: Constants.APARTMENT_LOCATION, identifier: "Apartment", locationManager: locationManager)
            
            Utils.monitorRegion(location: Constants.HOUSE_LOCATION, identifier: "House", locationManager: locationManager)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started monitoring regions: \(manager.monitoredRegions)")
    }
    
    /**
     Automatically open the garage when users arrive at the apartment
     */
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("User entered \(region.identifier) region")
        
        if region.identifier == "House" {
            return
        }
        
        Utils.getSetting(setting: "open_upon_arrival") { (value, err) -> () in
            // If user doesn't want to open upon arrival, don't send move request
            if !value || err != "" {
                print("Don't open door automatically")
                return
            }
            
            // Otherwise, send move request automatically
            Utils.moveGarage(mode: "open") { (status, err) -> () in
                if err != "" {
                    // If the error pertains to recently leaving the apartment, ignore sending the notification
                    if err.contains("recent") {
                        return
                    }
                    
                    // Send error message
                    self.notifications.add(Utils.createFailedOpenNotification(err), withCompletionHandler: nil)
                    return
                }
                
                self.notifications.add(Utils.createOpeningNotification(), withCompletionHandler: nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("User exited \(region.identifier) region")
        
        Request.send(url: "https://jlemon.org/garage/updateregionexittime/\(Auth.TOKEN)")
        
        Utils.getSetting(setting: "notify_on_exit_region") { (value, err) -> () in
            // If user doesn't want to notify upon exit, don't send notify request
            if !value || err != "" {
                print("Don't notify on exit region")
                return
            }
            
            self.notifications.add(Utils.createExitRegionNotification(), withCompletionHandler: nil)
        }
    }
    
    /**
    Record travel history of users to later generate heatmaps for those who opt in
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            Utils.getSetting(setting: "record_location_history") { (value, err) -> () in
                // If user doesn't want to open upon arrival, don't send move request
                if !value || err != "" {
                    return
                }
                
                Request.send(url: "https://jlemon.org/rs/\(Auth.TOKEN)/\(location.coordinate.latitude)/\(location.coordinate.longitude)/\(location.horizontalAccuracy)")
            }
        }
    }
    
    /**
     Update user's notification device token when the app opens
     */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device token: \(token)")
        
        Request.send(url: "https://jlemon.org/garage/updatedevicetoken/\(Auth.TOKEN)/\(token)")
    }


}

