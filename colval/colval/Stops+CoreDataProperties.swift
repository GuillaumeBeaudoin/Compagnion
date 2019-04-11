//
//  Stops+CoreDataProperties.swift
//  colval
//
//  Created by user150454 on 4/11/19.
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
    @NSManaged public var stop_code: Int16
    @NSManaged public var stop_id: Int16
    @NSManaged public var stop_name: String?
    @NSManaged public var wheelchair_boarding: Bool
    @NSManaged public var zonex: Int16
    @NSManaged public var stopTimes: StopTimes?

}
