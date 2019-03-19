//
//  User.swift
//  ColValCompagnon
//
//  Created by Alexandre Arsenault on 2019-02-26.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation



class User :Codable{
    
    var ID : String?
    var deviceID : String
    
    init(pID : String , pDeviceID: String  ) {
        self.ID   = pID
        self.deviceID     = pDeviceID
    }
    
    init( pDeviceID: String  ) {
        self.deviceID     = pDeviceID
    }
    
    
}
