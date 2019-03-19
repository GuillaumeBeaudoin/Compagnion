//
//  File.swift
//  ColValCompagnon2
//
//  Created by user150454 on 2/26/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation


class routes{
    
    var route_id: Int
    var agency_id: Int
    var route_name: String
    //var route_long_name: String
    var route_type: String
    //var route_color: String
    //var route_text_color: String
   


    init(route_id: Int, agency_id: Int, route_name: String, route_type: String ) {
        
        
        
      self.route_id = route_id
        self.agency_id = agency_id
        self.route_name = route_name
        self.route_type = route_type
        
        
    }




}
