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
    var DA : Int
    
    init(pID : String , pDA: Int  ) {
        self.ID   = pID
        self.DA   = pDA
    }
    
    init( pDA: Int  ) {
        self.DA   = pDA
    }
    
    
}
