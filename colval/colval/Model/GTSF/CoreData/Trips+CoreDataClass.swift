//
//  Trips+CoreDataClass.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Trips)
public class Trips: NSManagedObject {
    
    
    public init(pId : String , pServiceId : String , pHeadsign : String , pDirectionId: Int16 ,   pShortName :String) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Trips", in: CoreData.sharedInstance.context)!, insertInto: CoreData.sharedInstance.context)
        self.trip_id  =   pId
        self.service_id = pServiceId
        self.trip_headsign = pHeadsign
        self.direction_id =  pDirectionId   // Int16 
        self.trip_short_name =  pShortName //String?
    }
    
  
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

}
