//
//  Shape+CoreDataProperties.swift
//  colval
//
//  Created by user150454 on 4/11/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData


extension Shape {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shape> {
        return NSFetchRequest<Shape>(entityName: "Shape")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var sequence: Double
    @NSManaged public var shape_id: Int16
    @NSManaged public var traveled: Double
    @NSManaged public var trip: Trips?

}
