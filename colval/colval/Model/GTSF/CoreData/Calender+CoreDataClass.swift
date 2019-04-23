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
    
    public init(pServiceId:String , pMonday:Bool, pTuesday:Bool , pWednesday:Bool,pThursday:Bool , pFriday:Bool ,pSaturday:Bool ,pSunday:Bool , pStartDate:Date, pEndDate:Date) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Calender",
                                                      in:            CoreData.sharedInstance.context)!,
                                                      insertInto:    CoreData.sharedInstance.context)
        self.service_id    =  pServiceId
        self.monday        =  pMonday
        self.tuesday       =  pTuesday
        self.wednesday     =  pWednesday
        self.thursday      =  pThursday
        self.friday        =  pFriday
        self.saturday      =  pSaturday
        self.sunday        =  pSunday
        self.start_date    =  pStartDate
        self.end_date      =  pEndDate
    }
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    } 
}
