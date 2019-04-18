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
    
    public init(pId:Int16,pAgencyId : String, pShortName:String, pLongName:String, pColor : String , pTextColor: String , pType:String) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Routes", in: CoreData.sharedInstance.context)!, insertInto: CoreData.sharedInstance.context)
        self.route_id         = pId
        self.agency_id        = pAgencyId
        self.route_short_name = pShortName
        self.route_long_name  = pLongName
        self.route_type       = pType
        self.route_color      = pColor
        self.route_text_color = pTextColor
    }
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

}
