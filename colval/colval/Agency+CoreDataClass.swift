//
//  Agency+CoreDataClass.swift
//  colval
//
//  Created by user150454 on 4/11/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Agency)
public class Agency: NSManagedObject {
    
    public init(pAgencyId : Int16, pAgencyName:Int16,pRoutes:NSSet?) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Agency", in: CoreData().context)!, insertInto: CoreData().context)
        self.agency_id = pAgencyId
        self.agency_name =  pAgencyName
        self.routes =  pRoutes 
    }
    
    public init( pAgencyName:Int16,pRoutes:NSSet?) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Agency", in: CoreData().context)!, insertInto: CoreData().context)
        self.agency_name =  pAgencyName
        self.routes =  pRoutes
    }
    
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    

}
