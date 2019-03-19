//
//  Rent.swift
//  ColValCompagnon
//
//  Created by Alexandre Arsenault on 2019-02-26.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation


class Rent :Codable{
    
    var ID : String?
    var renterID : String
    var parkingID : String
    var dateFrom: String
    var dateTo: String
    
    init(pID : String , pRenterID: String , pParkingID: String,  dateFrom: String, dateTo: String) {
        
        
        self.dateTo = dateTo
        self.ID   = pID
        self.renterID     = pRenterID
        self.parkingID    = pParkingID
        self.dateFrom  = dateFrom
        self.dateTo = dateTo
    }
    
    init( pRenterID: String , pParkingID: String, dateFrom: String, dateTo: String) {
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.renterID     = pRenterID
        self.parkingID    = pParkingID
        self.dateFrom  = dateFrom
        self.dateTo = dateTo
    }
    
    
}

