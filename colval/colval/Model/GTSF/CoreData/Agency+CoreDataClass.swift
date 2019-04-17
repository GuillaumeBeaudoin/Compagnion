//
//  Agency+CoreDataClass.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Agency)
public class Agency: NSManagedObject {
    
    public init(pAgencyId : String, pAgencyName:String,pRoutes:NSSet?) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Agency", in: CoreData.sharedInstance.context)!, insertInto: CoreData.sharedInstance.context)
        self.agency_id = pAgencyId
        self.agency_name =  pAgencyName
        self.routes =  pRoutes
    }
    
    public init(pAgencyId : String, pAgencyName:String) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Agency", in: CoreData.sharedInstance.context)!, insertInto: CoreData.sharedInstance.context)
        self.agency_id = pAgencyId
        self.agency_name =  pAgencyName
    }
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

}
