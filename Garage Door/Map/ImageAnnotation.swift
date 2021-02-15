//
//  ImageAnnotation.swift
//  Garage Door
//
//  Created by Joey Lemon on 6/28/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import UIKit
import MapKit

class ImageAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var colour: UIColor?

    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.image = nil
        self.colour = UIColor.white
    }
    
}
