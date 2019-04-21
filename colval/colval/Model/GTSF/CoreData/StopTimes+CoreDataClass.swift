//
//  StopTimes+CoreDataClass.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData

@objc(StopTimes)
public class StopTimes: NSManagedObject {
    public init( pArrivalTime:   Date?  , pDepartureTime : Date? , pStopSequence : Int16 , pPickupType  : Bool , pDropOffType : Bool , pTraveled : Double , pTimepoint : Int16 , pLazyTripId : String , pLazyStopId : String ) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "StopTimes",
                                                      in:            CoreData.sharedInstance.context)!,
                   insertInto:    CoreData.sharedInstance.context)
        self.arrival_time   = pArrivalTime
        self.departure_time = pDepartureTime
        self.stop_sequence  = pStopSequence
        self.pickup_type    = pPickupType
        self.drop_off_type  = pDropOffType
        self.traveled       = pTraveled
        self.timepoint      = pTimepoint
        
        self.lazy_stop_id   =  pLazyStopId
        self.lazy_trip_id   =  pLazyTripId
    }
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
