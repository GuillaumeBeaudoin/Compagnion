//
//  pin.swift
//  ColValCompagnon2
//
//  Created by user150454 on 3/19/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
import MapKit
import Foundation
class pin : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title:String?
    var subTitle: String?
    
    
     init(pinTitle: String, pinSubtible: String, location: CLLocationCoordinate2D){
        self.title = pinTitle
        self.subTitle = pinSubtible
        self.coordinate = location
    }
    
    
    
    
}
