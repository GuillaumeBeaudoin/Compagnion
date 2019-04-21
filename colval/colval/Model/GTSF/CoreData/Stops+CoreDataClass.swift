//
//  Stops+CoreDataClass.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Stops)
public class Stops: NSManagedObject { 
    public init( pId : String , pName : String? , pLat : Double , pLon : Double, pZone : String? , pCode : String? , pWheelchairBoarding : Bool) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Stops",
                                                      in:            CoreData.sharedInstance.context)!,
                   insertInto:    CoreData.sharedInstance.context)
        self.lazy_id             = pId
        self.name                = pName
        self.lat                 = pLat
        self.lon                 = pLon
        self.zonex               = pZone
        self.code                = pCode
        self.wheelchair_boarding = pWheelchairBoarding
    }
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
