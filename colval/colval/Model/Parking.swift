//
//  Parking.swift
//  ColValCompagnon
//
//  Created by Alexandre Arsenault on 2019-02-26.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
import MapKit
import Foundation




class Parking : NSObject, MKAnnotation{
    
    var id : String?
    var posX : Double
    var posY : Double
    var orientation : Bool // horisontal = true  : vertical = false
    
    var coordinate: CLLocationCoordinate2D
    var title:String?
    var subTitle: String?
    
    init(pID : String , pPosX:Double  , pPosY:Double  , pOrientation:Bool  ) {
        self.id           = pID
        self.posX         = pPosX
        self.posY         = pPosY
        self.orientation  = pOrientation
        
        self.coordinate   = CLLocationCoordinate2D(latitude: posX, longitude: posX)
        self.title        = "Parking"
        self.subTitle     = "Parking"
    }
    
    init( pPosX:Double  , pPosY:Double  , pOrientation:Bool  ) {
        self.posX         = pPosX
        self.posY         = pPosY
        self.orientation  = pOrientation
        
        self.coordinate   = CLLocationCoordinate2D(latitude: posX, longitude: posX)
        self.title        = "Parking"
        self.subTitle     = "Parking"
    }
     
}

