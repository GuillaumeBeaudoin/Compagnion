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
     * Tell if the General Transit Specification Feed
     * has been loaded into the Context.
     */
    func isGTSFLoaded() -> Bool {
        do {
            let requestAgency : NSFetchRequest<Agency> = Agency.fetchRequest()
            let agencys =  try context.fetch(requestAgency)
            return agencys.count > 0 
        } catch  {
            print("isGTSFLoaded() Error")
            return false
        }
    }
    
    func getAgencyFromId( pAgencyId : String )  -> Agency? {
        do{
            let request : NSFetchRequest<Agency> = Agency.fetchRequest()
            request.predicate = NSPredicate(format: "agency_id =  %@", pAgencyId)
            let results =  try context.fetch(request)
            if results.count == 1 {
                return results[0]
            } else {
                print("CoreData.getAgencyFromId(\(pAgencyId))  : NIL  \(results.count)")
                return nil
            }
        } catch let error {
        print("CoreData.getAgencyFromId() Error: \(error)")
        }
        return nil
    }
    
    func getShapeFromId( pShapeId : Int32! )  -> [Shape]? {
        do{
            let request : NSFetchRequest<Shape> = Shape.fetchRequest()
            request.predicate = NSPredicate(format: "id == \(pShapeId!)")
            let results =  try context.fetch(request)
            if results.count > 0 {
                return results
            } else {
                print("CoreData.getShapeFromId(\(pShapeId))  : NIL")
                return nil
            }
            
        } catch let error {
            print("CoreData.getShapeFromId() Error: \(error)")
        }
        return nil
    }
    
    func getRouteFromId( pRouteId :  Int16! )  -> Routes? {
        do{
            let request : NSFetchRequest<Routes> = Routes.fetchRequest()
            request.predicate = NSPredicate(format: "route_id == \(pRouteId!)")
            let results =  try context.fetch(request)
            if results.count == 1 {
                return results[0]
            } else {
                print("CoreData.getRouteFromId(\(pRouteId))  : NIL \(results.count)")
                return nil
            }
        } catch let error {
            print("CoreData.getRouteFromId() Error: \(error)")
        }
        return nil
    }
    
    func getTripFromId( pTripId : String )  -> Trips? {
        do{
            let request : NSFetchRequest<Trips> = Trips.fetchRequest()
            request.predicate = NSPredicate(format: "trip_id =  %@", pTripId)
            let results =  try context.fetch(request)
            if results.count == 1 {
                return results[0]
            } else {
                print("CoreData.getTripFromId(\(pTripId))  : NIL")
                return nil
            }
        } catch let error {
            print("CoreData.getTripFromId() Error: \(error)")
        }
        return nil
    }
    
    func getStopFromId( pStopId : String )  -> Stops? {
        do{
            let request : NSFetchRequest<Stops> = Stops.fetchRequest()
            request.predicate = NSPredicate(format: "stop_id =  %@", pStopId)
            let results =  try context.fetch(request)
            if results.count == 1 {
                return results[0]
            } else {
                print("CoreData.getStopFromId(\(pStopId))  : NIL")
                 return nil
            } 
        } catch let error {
            print("CoreData.getStopFromId() Error: \(error)")
        }
        return nil
    }
    
    //** test function
    func printAllTripFromId()  {
        do{
            let request : NSFetchRequest<Trips> = Trips.fetchRequest()
            let results =  try context.fetch(request)
            if results.count > 0 {
                for trip in results {
                    print("\(trip.routes?.route_long_name)/\(trip.trip_headsign) , count : \(results.count)  ")
                }
            } else {
                print("CoreData.printAllRouteFromId()  : no result \(results.count)")
            }
        } catch let error {
            print("CoreData.printAllRouteFromId() Error: \(error)")
        }
    }
        
}
