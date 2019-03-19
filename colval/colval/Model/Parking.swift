//
//  Parking.swift
//  ColValCompagnon
//
//  Created by Alexandre Arsenault on 2019-02-26.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation




class Parking :Codable{
    
    var id : String?
    var posX : Int
    var posY : Int
    var orientation : Bool // horisontal = true  : vertical = false
    
    init(pID : String , pPosX:Int  , pPosY:Int  , pOrientation:Bool  ) {
        self.id           = pID
        self.posX         = pPosX
        self.posY         = pPosY
        self.orientation  = pOrientation
    }
    
    init( pPosX:Int  , pPosY:Int  , pOrientation:Bool  ) {
        self.posX         = pPosX
        self.posY         = pPosY
        self.orientation  = pOrientation
    }
     
}

