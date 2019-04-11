//
//  File.swift
//  ColValCompagnon2
//
//  Created by user150454 on 2/26/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation


class fare_attributes {

    var fare_id: Int
    var  price: Double
   // currency_type
  //  payment_method
    var transfers: Bool
   // transfer_duration
    
    
    init(fare_id: Int, price: Double, transfers: Bool) {
        
        self.fare_id = fare_id
        self.price = price
        self.transfers  = transfers
        
        
        
    }
    
    
    
}

