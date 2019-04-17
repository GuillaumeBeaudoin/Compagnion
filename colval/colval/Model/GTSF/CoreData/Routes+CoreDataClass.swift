//
//  Routes+CoreDataClass.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Routes)
public class Routes: NSManagedObject {
    
    
    public init(pAgencyId : String, pId:Int16,pName:String,pType:String) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Routes", in: CoreData.sharedInstance.context)!, insertInto: CoreData.sharedInstance.context)
        self.agency_id  = pAgencyId
        self.route_id   = pId
        self.route_name = pName
        self.route_type = pType
    }
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

}
