//
//  SettingsSection.swift
//  Garage Door
//
//  Created by Joey Lemon on 10/17/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import Foundation

class SettingsSection: Codable {
    
    //MARK: Properties
    var Name: String
    var Entries: [SettingsEntry]

    //MARK: Initialization
    init(Name: String, Entries: [SettingsEntry]) {
        self.Name = Name
        self.Entries = Entries
    }
    
}
