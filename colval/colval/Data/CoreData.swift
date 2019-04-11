//
//  CoreData.swift
//  TD6
//
//  Created by Alexandre Arsenault on 2019-04-03.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class CoreData  {
    
    
    let context  :NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    
    /*
    /*
     * Stop
     */
   
    func getStopsForRoute(pRouteId: Int) -> [Stop]  {
        do{
            let request  : NSFetchRequest<Stop> = Stop.fetchRequest()
            request.predicate = NSPredicate(format: "fullName == %a", pRouteId)
            /*
            return try context.fetch(request)
            */
            let stops = try context.fetch(request)
            for stop in stops {
                print("id= \(stops)" )
            }
            return stops
            
        } catch let error {
            print("getStudents() Error: \(error)")
        }
        return []
        
        
        
    }
    
    func getStopNear(pLocation:CLLocationCoordinate2D) -> [Stop]  {
         do{ 
            let request  : NSFetchRequest<Stop> = Stop.fetchRequest()
            //request.predicate = NSPredicate(format: "fullName contains %a", pName)
            return try context.fetch(request)
            
         } catch let error {
            print("getStudents() Error: \(error)")
        }
        return []
    }
    
    
    func deleteStop(pStop : Stop!) {
        do{
            context.delete(pStop)
            try context.save()
        } catch let error {
            print("deleteStop() Error: \(error)")
        }
     
    } */
    
}
