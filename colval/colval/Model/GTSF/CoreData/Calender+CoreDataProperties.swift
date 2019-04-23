//
//  Calender+CoreDataProperties.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData


extension Calender {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Calender> {
        return NSFetchRequest<Calender>(entityName: "Calender")
    }

    @NSManaged public var dayInFunction: String?
    @NSManaged public var end_date: NSDate?
    @NSManaged public var service_id: Int16
    @NSManaged public var start_date: NSDate?
    @NSManaged public var lazy_trip_id : String?
    @NSManaged public var monday : Bool
    @NSManaged public var tuesday : Bool
    @NSManaged public var wednesday : Bool
    @NSManaged public var thursday : Bool
    @NSManaged public var friday : Bool
    @NSManaged public var saturday : Bool
    @NSManaged public var sunday : Bool
    
    
    @NSManaged public var trip: Trips?

}
