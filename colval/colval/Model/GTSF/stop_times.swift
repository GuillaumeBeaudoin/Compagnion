//
//  File.swift
//  ColValCompagnon2
//
//  Created by user150454 on 2/26/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation




class stop_times{
    
   var trip_id: Int
  var  arrival_time: Date
    var departure_time: Date
    var stop_id: Int
    var  stop_sequence: Int
    var pickup_type : Int
    var  drop_off_type: Int
    var traveled: Double
    var timepoint : Bool
    
    
    
    init (
         trip_id: Int,
      arrival_time: Date,
     departure_time: Date,
     stop_id: Int,
      stop_sequence: Int,
     pickup_type : Int,
      drop_off_type: Int,
     traveled: Double,
     timepoint : Bool
        
        
        ){
        
        
        self.trip_id = trip_id
        self.arrival_time = arrival_time
        self.departure_time = departure_time
        self.stop_id = stop_id
        self.stop_sequence = stop_sequence
        self.pickup_type = pickup_type
        self.drop_off_type = drop_off_type
        self.traveled = traveled
        self.timepoint = timepoint
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}
