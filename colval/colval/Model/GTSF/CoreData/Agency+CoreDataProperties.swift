//
//  Agency+CoreDataProperties.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData


extension Agency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Agency> {
        return NSFetchRequest<Agency>(entityName: "Agency")
    }

    @NSManaged public var agency_id: String?
    @NSManaged public var agency_name: String?
    @NSManaged public var routes: NSSet?

}

// MARK: Generated accessors for routes
extension Agency {

    @objc(addRoutesObject:)
    @NSManaged public func addToRoutes(_ value: Routes)

    @objc(removeRoutesObject:)
    @NSManaged public func removeFromRoutes(_ value: Routes)

    @objc(addRoutes:)
    @NSManaged public func addToRoutes(_ values: NSSet)

    @objc(removeRoutes:)
    @NSManaged public func removeFromRoutes(_ values: NSSet)

}
