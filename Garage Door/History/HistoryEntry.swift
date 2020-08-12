//
//  HistoryEntry.swift
//  Garage Door
//
//  Created by Joey Lemon on 6/17/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import Foundation

class HistoryEntry : Codable {
    
    //MARK: Properties
    var PersonName: String
    var PersonColor: [Int]
    var Action: String
    var Date: String

    //MARK: Initialization
    init(PersonName: String, PersonColor: [Int], Action: String, Date: String) {
        self.PersonName = PersonName
        self.PersonColor = PersonColor
        self.Action = Action
        self.Date = Date
    }
    
}
