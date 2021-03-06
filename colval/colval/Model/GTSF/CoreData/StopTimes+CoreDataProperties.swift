//
//  StopTimes+CoreDataProperties.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData


extension StopTimes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StopTimes> {
        return NSFetchRequest<StopTimes>(entityName: "StopTimes")
    }

    @NSManaged public var arrival_time: NSDate?
    @NSManaged public var departure_time: NSDate?
    @NSManaged public var drop_off_type: Bool
    @NSManaged public var pickup_type: Bool
    @NSManaged public var stop_sequence: Int16
    @NSManaged public var timepoint: Int16
    @NSManaged public var traveled: Double
    
    @NSManaged public var lazy_stop_id: String
    @NSManaged public var stop: NSSet?
    @NSManaged public var lazy_trip_id:Stops?
    @NSManaged public var trip: Trips?

}

// MARK: Generated accessors for stop
extension StopTimes {

    @objc(addStopObject:)
    @NSManaged public func addToStop(_ value: Stops)

    @objc(removeStopObject:)
    @NSManaged public func removeFromStop(_ value: Stops)

    @objc(addStop:)
    @NSManaged public func addToStop(_ values: NSSet)

    @objc(removeStop:)
    @NSManaged public func removeFromStop(_ values: NSSet)

}
