//
//  Utils.swift
//  Garage Door
//
//  Created by Joey Lemon on 7/8/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import Foundation
import UserNotifications

class Utils {
    
    /**
     Format a date string (in the format "yyyy-MM-dd HH:mm:ss") to a human-readable format
     such as "Today at 5:00PM" or "Monday at 3:00PM"
     
     - Parameter dateString: The date string to convert to a human-readable format
     - Returns: A formatted human-readable string
     */
    static func formatDate(_ dateString: String) -> String {
        let calendar = Calendar.current
        
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inFormatter.timeZone = TimeZone(identifier: "America/New_York")
        
        if let date = inFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.amSymbol = "am"
            formatter.pmSymbol = "pm"
            
            // Convert from EST to the current timezone
            formatter.timeZone = TimeZone.current
            
            // Today
            if calendar.isDateInToday(date) {
                formatter.dateFormat = "'Today at' h:mma"
                
            // Yesterday
            } else if calendar.isDateInYesterday(date) {
                formatter.dateFormat = "'Yesterday at' h:mma"
                
            // Within the last week
            } else if Date().timeIntervalSince(date) < 60 * 60 * 24 * 7 {
                formatter.dateFormat = "EEEE 'at' h:mma"
                
            // Older than a week
            } else {
                formatter.dateFormat = "MMMM d 'at' h:mma"
            }
            
            return formatter.string(from: date)
        }
        
        return "Invalid date"
    }
    
    // (Bool, Bool) -> (closed, isError)
    static func moveGarage(onlyOpen: Bool, completion: @escaping (Bool, Bool) -> ()) {
        // Send a request to the web server to open the garage
        Request.send(url: "https://jlemon.org/garage/\(onlyOpen ? "open" : "move")/\(Auth.TOKEN)") { (response, result) -> () in
            let httpResponse = response as! HTTPURLResponse
            
            // If the API didn't return 200 OK, something went wrong
            if httpResponse.statusCode != 200 {
                completion(false, true)
                return
            }
            
            completion(String(data: result!, encoding: .utf8) == "true", false)
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
    
    static func createFailedOpenNotification() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "Failed to open garage"
        content.body = "Could not automatically open the garage, likely because it is already open"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "piopener-app-failed-open", content: content, trigger: trigger)
        
        return request
    }
    
}
