//
//  Utils.swift
//  Garage Door
//
//  Created by Joey Lemon on 7/8/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation
import Intents

class Utils {
    
    /**
    Register a new region to monitor for entering and exiting
     */
    static func monitorRegion(location: CLLocationCoordinate2D, identifier: String, locationManager: CLLocationManager) {
        let region = CLCircularRegion(
            center: location,
            radius: Constants.REGION_RADIUS, identifier: identifier)
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .otherNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.startUpdatingLocation()

        locationManager.startMonitoring(for: region)
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    /**
     Format a date string (in the format "yyyy-MM-dd HH:mm:ss") to a human-readable format
     such as "Today at 5:00PM" or "Monday at 3:00PM"
     
     - Parameter dateString: The date string to convert to a human-readable format
     - Returns: A formatted human-readable string
     */
    static func formatDate(_ dateString: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inFormatter.timeZone = TimeZone(identifier: "America/New_York")
        
        if let date = inFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.amSymbol = "am"
            formatter.pmSymbol = "pm"
            
            // Convert from EST to the current timezone
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "'at' h:mma"
            
            return formatter.string(from: date)
        }
        
        return "Invalid date"
    }
    
    // (String, String) -> (status, error)
    static func moveGarage(mode: String, completion: @escaping (String, String) -> ()) {
        // Send a request to the web server to open the garage
        Request.send(url: "https://jlemon.org/garage/\(mode)/\(Auth.TOKEN)") { (response, result) -> () in
            let httpResponse = response as! HTTPURLResponse
            let body = String(data: result!, encoding: .utf8)
            
            // If the API didn't return 200 OK, something went wrong
            if httpResponse.statusCode != 200 {
                completion("", body ?? "Unknown error")
                return
            }
            
            completion(body!, "")
        }
    }
    
    // (Bool, String) -> (value, error)
    static func getSetting(setting: String, completion: @escaping (Bool, String) -> ()) {
        // Send a request to the web server to open the garage
        Request.send(url: "https://jlemon.org/garage/settings/get/\(Auth.TOKEN)/\(setting)") { (response, result) -> () in
            let httpResponse = response as! HTTPURLResponse
            let body = String(data: result!, encoding: .utf8)
            
            // If the API didn't return 200 OK, something went wrong
            if httpResponse.statusCode != 200 {
                completion(false, body ?? "Unknown error")
                return
            }
            
            completion(body == "true", "")
        }
    }
    
    static func createOpeningNotification() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "Opening garage ..."
        content.body = "The garage is now opening because you have arrived at the apartment"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "piopener-app-opening", content: content, trigger: trigger)
        
        return request
    }
    
    static func createFailedOpenNotification(_ err: String) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "Failed to open garage"
        content.body = "Could not automatically open the garage: " + err
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "piopener-app-failed-open", content: content, trigger: trigger)
        
        return request
    }
    
    static func createExitRegionNotification() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "You have left the apartment"
        content.body = "Your GPS location no longer shows you at the apartment"
        content.sound = .defaultCritical

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "piopener-app-exited-region", content: content, trigger: trigger)
        
        return request
    }
    
    static func donateOpenGarageIntent() {
        let intent = OpenGarageIntent()
        intent.suggestedInvocationPhrase = "Open the garage door"
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("donation failed: \(error)")
                } else {
                    print("donation failed")
                }
            } else {
                print("successfully donated open garage interaction")
            }
        }
    }
    
    static func donateCloseGarageIntent() {
        let intent = CloseGarageIntent()
        intent.suggestedInvocationPhrase = "Close the garage door"
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("donation failed: \(error)")
                } else {
                    print("donation failed")
                }
            } else {
                print("successfully donated close garage interaction")
            }
        }
    }
    
}
