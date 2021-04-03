//
//  Constants.swift
//  Garage Door
//
//  Created by Joey Lemon on 6/27/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import Foundation
import CoreLocation

class Constants {
    
    // How long the garage takes to open/close
    static var OPEN_DURATION = 20.0
    
    // The coordinates of the apartment
    static var APARTMENT_LOCATION = CLLocationCoordinate2D(
        latitude: 35.902790,
        longitude: -84.087259)
    
    // The coordinates of the house
    static var HOUSE_LOCATION = CLLocationCoordinate2D(
        latitude: 35.9583253,
        longitude: -85.712751)
    
    // Radius of the area to monitor for arrival at the apartment coordinates (in meters)
    static var REGION_RADIUS = 45.0
    
}
