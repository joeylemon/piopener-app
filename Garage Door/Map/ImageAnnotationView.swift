//
//  ImageAnnotationView.swift
//  Garage Door
//
//  Created by Joey Lemon on 6/28/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import UIKit
import MapKit

class ImageAnnotationView: MKAnnotationView {

    private var imageView: UIImageView!
    
    private var width = 40

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        self.frame = CGRect(x: 0, y: 0, width: self.width, height: self.width)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.width))
        self.addSubview(self.imageView)

        self.imageView.layer.cornerRadius = CGFloat(self.width/2)
        self.imageView.layer.borderWidth = 2.0
        self.imageView.layer.borderColor = UIColor.darkGray.cgColor
        self.imageView.layer.masksToBounds = true
    }

    override var image: UIImage? {
        get {
            return self.imageView.image
        }

        set {
            self.imageView.image = newValue
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
