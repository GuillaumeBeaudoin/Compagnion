//
//  File.swift
//  ColValCompagnon2
//
//  Created by user150454 on 2/26/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation


class trips {
    
    var route_id: Int
    var service_id: Int
    var trip_id: Int
    var trip_headsign: String
    var direction_id: Int
    var shape_id: Int
    var trip_short_name: String
    
    
    
    init (route_id: Int
    , service_id: Int
    , trip_id: Int
    , trip_headsign: String
    , direction_id: Int
    , shape_id: Int
    , trip_short_name: String
        )
    {
        
        
            self.route_id = route_id
            self.service_id = service_id
            self.trip_id = trip_id
            self.trip_headsign = trip_headsign
            self.direction_id = direction_id
            self.shape_id = shape_id
            self.trip_short_name = trip_short_name
        
        
        
    }
    
    
    
    
}
