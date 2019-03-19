//
//  File.swift
//  ColValCompagnon2
//
//  Created by user150454 on 2/26/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation



class stops{
    var stop_id: Int
  var  stop_name: String
   var lat: Double
 var   lon: Double
 var   zone: Int
 var   stop_code: Int
  var  wheelchair_boarding: Bool
    
    
    init (
    stop_id: Int,
    stop_name: String,
    lat: Double,
    lon: Double,
    zone: Int,
    stop_code: Int,
    wheelchair_boarding: Bool
    )
    {
        
        
        self.stop_id = stop_id
            self.stop_name = stop_name
            self.lat = lat
            self.lon = lon
            self.zone = zone
            self.stop_code = stop_code
            self.wheelchair_boarding = wheelchair_boarding
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
