//
//  Routes+CoreDataProperties.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-17.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData


extension Routes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routes> {
        return NSFetchRequest<Routes>(entityName: "Routes")
    }

    @NSManaged public var agency_id: String?
    @NSManaged public var route_id: Int16
    @NSManaged public var route_short_name: String?
    @NSManaged public var route_type: String?
    @NSManaged public var route_long_name: String?
    @NSManaged public var route_color: String?
    @NSManaged public var route_text_color: String?
    @NSManaged public var agency: Agency?
    @NSManaged public var calendars: Calender?
    @NSManaged public var trips: NSSet?

}

// MARK: Generated accessors for trips
extension Routes {

    @objc(addTripsObject:)
    @NSManaged public func addToTrips(_ value: Trips)

    @objc(removeTripsObject:)
    @NSManaged public func removeFromTrips(_ value: Trips)

    @objc(addTrips:)
    @NSManaged public func addToTrips(_ values: NSSet)

    @objc(removeTrips:)
    @NSManaged public func removeFromTrips(_ values: NSSet)

}
