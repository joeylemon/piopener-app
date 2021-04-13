//
//  OpenGarageIntentHandler.swift
//  Garage Door Intent
//
//  Created by Joey Lemon on 4/13/21.
//  Copyright © 2021 Joey Lemon. All rights reserved.
//

import Foundation

class OpenGarageIntentHandler: NSObject, OpenGarageIntentHandling {
    
    func handle(intent: OpenGarageIntent, completion: @escaping (OpenGarageIntentResponse) -> Void) {
        Utils.moveGarage(mode: "open") { (status, err) -> () in
            if err != "" {
                print("Err: " + err)
                
                if err.lowercased().contains("already open") {
                    completion(OpenGarageIntentResponse(code: .failureAlreadyOpen, userActivity: nil))
                } else if err.lowercased().contains("too many requests") {
                    completion(OpenGarageIntentResponse(code: .failureTooManyRequests, userActivity: nil))
                } else {
                    completion(OpenGarageIntentResponse(code: .failure, userActivity: nil))
                }
                
                return
            }
            
            completion(OpenGarageIntentResponse(code: .success, userActivity: nil))
        }
    }
    
}
