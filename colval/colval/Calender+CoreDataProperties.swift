//
//  Calender+CoreDataProperties.swift
//  colval
//
//  Created by user150454 on 4/11/19.
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
    @NSManaged public var routes: Routes?

}
