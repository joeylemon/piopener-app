//
//  SettingsEntry.swift
//  Garage Door
//
//  Created by Joey Lemon on 10/17/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import Foundation

class SettingsEntry: Codable {
    
    //MARK: Properties
    var SettingName: String
    var SettingKey: String
    var Description: String
    var Enabled: Bool

    //MARK: Initialization
    init(SettingName: String, SettingKey: String, Description: String, Enabled: Bool) {
        self.SettingName = SettingName
        self.SettingKey = SettingKey
        self.Description = Description
        self.Enabled = Enabled
    }
    
}
