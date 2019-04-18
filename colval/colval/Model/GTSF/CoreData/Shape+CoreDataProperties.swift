//
//  Shape+CoreDataProperties.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-18.
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
    @NSManaged public var sequence: Int32
    @NSManaged public var id: Int32
    @NSManaged public var traveled: Double
    @NSManaged public var trip: Trips?
    
}
