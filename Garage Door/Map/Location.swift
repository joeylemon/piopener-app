//
//  Location.swift
//  Garage Door
//
//  Created by Joey Lemon on 6/28/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import Foundation

class Location : Codable {
    
    //MARK: Properties
    var Name: String
    var Latitude: Double
    var Longitude: Double
    var Time: String
    var Accuracy: Double

    //MARK: Initialization
    init(Name: String, Latitude: Double, Longitude: Double, Time: String, Accuracy: Double) {
        self.Name = Name
        self.Latitude = Latitude
        self.Longitude = Longitude
        self.Time = Time
        self.Accuracy = Accuracy
    }
    
}
