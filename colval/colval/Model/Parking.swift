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
    var numero : Int
    
    var coordinate: CLLocationCoordinate2D
    var title:String?
    var subtitle: String?
    
    init(pID : String , pPosX:Double  , pPosY:Double  , pNumero:Int  ) {
        self.id           = pID
        self.posX         = pPosX
        self.posY         = pPosY
        self.numero       = pNumero
        
        self.coordinate   = CLLocationCoordinate2D(latitude: posX, longitude: posY)
        self.title        = "Parking #\(self.numero)"
        self.subtitle     = id
    }
    
    init( pPosX:Double  , pPosY:Double  , pNumero:Int  ) {
        self.posX         = pPosX
        self.posY         = pPosY
        self.numero       = pNumero
        
        self.coordinate   = CLLocationCoordinate2D(latitude: posX, longitude: posY)
        self.title        = "Parking #\(self.numero)"
        self.subtitle     = id
    }
     
}

