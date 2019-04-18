//
//  Shape+CoreDataClass.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Shape)
public class Shape: NSManagedObject {
    public init( pId : Int32 , pLat : Double , pLon : Double, pSequence : Int32 , pTraveled : Double ) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Shape",
                                                      in:            CoreData.sharedInstance.context)!,
                                                      insertInto:    CoreData.sharedInstance.context)
        self.id        = pId
        self.lat       = pLat
        self.lon       = pLon
        self.sequence  = pSequence
        self.traveled  = pTraveled
    }
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

}
