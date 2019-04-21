//
//  Stops+CoreDataProperties.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData


extension Stops {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stops> {
        return NSFetchRequest<Stops>(entityName: "Stops")
    }

    @NSManaged public var code: String?
    @NSManaged public var lat: Double
    @NSManaged public var lazy_id: String?
    @NSManaged public var lon: Double
    @NSManaged public var name: String?
    @NSManaged public var wheelchair_boarding: Bool
    @NSManaged public var zonex: String?
    @NSManaged public var stopTimes: NSSet?
    //@NSManaged public var stopTimes: Set<StopTimes>

}

// MARK: Generated accessors for stopTimes
extension Stops {

    @objc(addStopTimesObject:)
    @NSManaged public func addToStopTimes(_ value: StopTimes)

    @objc(removeStopTimesObject:)
    @NSManaged public func removeFromStopTimes(_ value: StopTimes)

    @objc(addStopTimes:)
    @NSManaged public func addToStopTimes(_ values: NSSet)

    @objc(removeStopTimes:)
    @NSManaged public func removeFromStopTimes(_ values: NSSet)

}
