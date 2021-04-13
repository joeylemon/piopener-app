//
//  CloseGarageIntentHandler.swift
//  Garage Door Intent
//
//  Created by Joey Lemon on 4/13/21.
//  Copyright © 2021 Joey Lemon. All rights reserved.
//

import Foundation

class CloseGarageIntentHandler: NSObject, CloseGarageIntentHandling {
    
    func handle(intent: CloseGarageIntent, completion: @escaping (CloseGarageIntentResponse) -> Void) {
        Utils.moveGarage(mode: "close") { (status, err) -> () in
            if err != "" {
                print("Err: " + err)
                
                if err.lowercased().contains("already closed") {
                    completion(CloseGarageIntentResponse(code: .failureAlreadyClosed, userActivity: nil))
                } else if err.lowercased().contains("too many requests") {
                    completion(CloseGarageIntentResponse(code: .failureTooManyRequests, userActivity: nil))
                } else {
                    completion(CloseGarageIntentResponse(code: .failure, userActivity: nil))
                }
                
                return
            }
            
            completion(CloseGarageIntentResponse(code: .success, userActivity: nil))
        }
    }
    
}
