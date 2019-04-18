//
//  Stops+CoreDataProperties.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData


extension Stops {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stops> {
        return NSFetchRequest<Stops>(entityName: "Stops")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var stop_code: String?
    @NSManaged public var stop_id: String?
    @NSManaged public var stop_name: String?
    @NSManaged public var wheelchair_boarding: Bool
    @NSManaged public var zonex: String?
    @NSManaged public var stopTimes: StopTimes?

}
