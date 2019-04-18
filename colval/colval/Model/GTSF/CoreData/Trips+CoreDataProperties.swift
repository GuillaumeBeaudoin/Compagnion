//
//  Trips+CoreDataProperties.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData


extension Trips {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trips> {
        return NSFetchRequest<Trips>(entityName: "Trips")
    }

    @NSManaged public var direction_id: Int16
    @NSManaged public var service_id: String? 
    @NSManaged public var trip_headsign: String?
    @NSManaged public var trip_id: String?
    @NSManaged public var trip_short_name: String?
    @NSManaged public var routes: Routes?
    @NSManaged public var shapes: NSSet?
    @NSManaged public var stoptimes: NSSet?

}

// MARK: Generated accessors for shapes
extension Trips {

    @objc(addShapesObject:)
    @NSManaged public func addToShapes(_ value: Shape)

    @objc(removeShapesObject:)
    @NSManaged public func removeFromShapes(_ value: Shape)

    @objc(addShapes:)
    @NSManaged public func addToShapes(_ values: NSSet)

    @objc(removeShapes:)
    @NSManaged public func removeFromShapes(_ values: NSSet)

}

// MARK: Generated accessors for stoptimes
extension Trips {

    @objc(addStoptimesObject:)
    @NSManaged public func addToStoptimes(_ value: StopTimes)

    @objc(removeStoptimesObject:)
    @NSManaged public func removeFromStoptimes(_ value: StopTimes)

    @objc(addStoptimes:)
    @NSManaged public func addToStoptimes(_ values: NSSet)

    @objc(removeStoptimes:)
    @NSManaged public func removeFromStoptimes(_ values: NSSet)

}
