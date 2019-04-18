//
//  Stops+CoreDataClass.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Stops)
public class Stops: NSManagedObject {
    public init( pId : String , pStopName : String? , pLat : Double , pLon : Double, pZone : String? , pStopCode : String? , pWheelchairBoarding : Bool) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Stops",
                                                      in:            CoreData.sharedInstance.context)!,
                   insertInto:    CoreData.sharedInstance.context)
        self.stop_id             = pId
        self.stop_name           = pStopName
        self.lat                 = pLat
        self.lon                 = pLon
        self.zonex               = pZone
        self.stop_code           = pStopCode
        self.wheelchair_boarding = pWheelchairBoarding
    }
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

}
