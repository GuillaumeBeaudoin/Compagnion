//
//  File.swift
//  ColValCompagnon2
//
//  Created by user150454 on 2/26/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation


class calender {
public var service_id: Int?
var dayInFunction = Array(repeating: 0, count: 7)
var start_date: Date?
var end_date: Date?



    init(service_id: Int, dayInFunction: Array<Int>, start_date: Date, end_date: Date) {
        
        
        self.service_id = service_id
        self.start_date = start_date
        self.end_date   = end_date
        
        
        
        
    }






}
