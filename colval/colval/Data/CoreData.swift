//
// CoreData.swift
// ColValCompagnon
//
// Created by Alexandre Arsenault on 2019-04-03.
// Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class CoreData {
    
    static let sharedInstance = CoreData()
    
    let context :NSManagedObjectContext
    
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    /*
     * Tell if the General Transit Specification Feed has been loaded.
     */
    func isGTSFLoaded() -> Bool {
        do {
            let requestAgency : NSFetchRequest<Agency> = Agency.fetchRequest()
            let agencys =  try context.fetch(requestAgency)
            //return agencys.count > 0
            return false
            
            
        } catch  {
            print("isGTSFLoaded() Error")
            return false
            
        }
        
    }
    
    func getAgencyFrom( pAgencyId : String )  -> Agency? {
    do{
        let request : NSFetchRequest<Agency> = Agency.fetchRequest()
        request.predicate = NSPredicate(format: "agency_id =  %@", pAgencyId)
        let results =  try context.fetch(request)
        if results.count == 1 {
            return results[0]
        } else {
            return nil
        }
        
    } catch let error {
    print("getAgencyFrom() Error: \(error)")
    }
    return nil
    }
    
    
    /*
    func getStopsForRoute(pRouteId: Int) -> [Stop] {
    do{
        let request : NSFetchRequest<Stop> = Stop.fetchRequest()
        request.predicate = NSPredicate(format: "fullName == %@", pRouteId)
        /*
         return try context.fetch(request)
         */
        let stops = try context.fetch(request)
        for stop in stops {
        } print("id= \(stops)" )
        return stops
    } catch let error {
      print("getStudents() Error: \(error)")
    return
    
    }
    
    func getStopNear(pLocation:CLLocationCoordinate2D) —> [Stop] {
    do{
        let request : NSFetchRequest<Stop> = Stop.fetchRequest()
        //request.predicate = NSPredicate(format: "fullName contains %a", pName)
        return try context.fetch(request)
    } catch let error {
        print("getStudents() Error: \(error)")
    }
    return []
    }
        */
}

