//
//  Calender+CoreDataClass.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Calender)
public class Calender: NSManagedObject {
    
    public init(pServiceId : Int16 , pDayInFunction : String, pStartDate:Date, pEndDate:Date) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Calender",
                                                      in:            CoreData.sharedInstance.context)!,
                                                      insertInto:    CoreData.sharedInstance.context)
        self.service_id    = pServiceId
        self.dayInFunction =  pDayInFunction
        self.start_date    =  pStartDate
        self.end_date      =  pEndDate
    }
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    } 
}
