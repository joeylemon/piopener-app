//
//  IntentHandler.swift
//  Garage Door Intent
//
//  Created by Joey Lemon on 4/13/21.
//  Copyright © 2021 Joey Lemon. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        if intent is OpenGarageIntent {
            return OpenGarageIntentHandler()
        } else if intent is CloseGarageIntent {
            return CloseGarageIntentHandler()
        }
        
        fatalError("Unhandled intent type: \(intent)")
    }
    
}
