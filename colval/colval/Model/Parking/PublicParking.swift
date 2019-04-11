//
//  PublicParking.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-09.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation


import MapKit
import Foundation




class PublicParking : Parking {
    
    override init(  pID : String , pPosX:Double  , pPosY:Double  , pNumero:Int  ) {
        super.init( pID: pID, pPosX: pPosX, pPosY: pPosY, pNumero: pNumero)
    }
    
    override init(  pPosX:Double  , pPosY:Double  , pNumero:Int  ) {
        super.init( pPosX: pPosX, pPosY: pPosY, pNumero: pNumero)
    }

}
