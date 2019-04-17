//
//  CSVUtil.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//    https://stackoverflow.com/questions/43295163/swift-3-1-how-to-get-array-or-dictionary-from-csv
//

import Foundation


class CSVUtil {
    
    static let sharedInstance = CSVUtil()
    
    
    
    private init() {
    }
    
    
    /***************************************************************
     **********************  GTSF -> LOADING ***********************
     ***************************************************************/
    
    static func loadGtsfToCoreData() -> Bool {
        loadCsvFile(pFile: "so_agency",  pClass : "Agency"    )
        loadCsvFile(pFile: "so_routes",  pClass : "Routes"    )
        /*
        loadCsvFile(pFile: "so_calendar",   pClass : "Routes")
        loadCsvFile(pFile: "so_trips",      pClass : "Routes"   )
        loadCsvFile(pFile: "so_shape",      pClass : "Routes"  )
        loadCsvFile(pFile: "so_stop_times", pClass : "Routes")
        loadCsvFile(pFile: "so_stops",      pClass : "Routes"   )
        
        loadCsvFile(pFile: "pi_agency",     pClass : "Routes"  )
        loadCsvFile(pFile: "pi_routes",     pClass : "Routes"   )
        loadCsvFile(pFile: "pi_calendar",   pClass : "Routes")
        loadCsvFile(pFile: "pi_trips",      pClass : "Routes"   )
        loadCsvFile(pFile: "pi_shape",      pClass : "Routes"   )
        loadCsvFile(pFile: "pi_stop_times", pClass : "Routes")
        loadCsvFile(pFile: "pi_stops",      pClass : "Routes"   )
        */
        return false
    }
    
    static func loadCsvFile(pFile: String , pClass : String) -> Bool {
        do {
            let cd = CoreData.sharedInstance
            
            // read the .csv File
            let filepath = try Bundle.main.path(forResource: pFile, ofType: "txt")
            var stringContents = try String(contentsOfFile: filepath!, encoding: .utf8)
            stringContents = stringContents
                .replacingOccurrences(of: "\r", with: "\n")
                .replacingOccurrences(of: "\n\n", with: "\n")
            
            var arrayObject: [[String]] = []
            let rows = stringContents.components(separatedBy: "\n")
            for i in  1...rows.count-1 {
                let columns = rows[i].components(separatedBy: ",")
                arrayObject.append(columns)
            }
            
            // add relation inside CoreData ( if necesary )
            if  pClass == "Agency" {
                //let wAgencys =  csvToAgencys(pCsvAgencys: arrayObject)
            }
            
            if  pClass == "Routes" {
                
                let wRoutes =  csvToRoutes(pCsvRoutes: arrayObject)
                for route in wRoutes {
                    if let agency =  cd.getAgencyFrom(pAgencyId: route.agency_id!) {
                        agency.addToRoutes(route) 
                    }
                }
            }
            /*
            if let _ = pObject as? Calender {
            }
            if let _ = pObject as? Trips {
            }
            if let _ = pObject as? Shape {
            }
            if let _ = pObject as? StopTimes {
            }
            if let _ = pObject as? Stops {
            }
            */
            
            //try CoreData.sharedInstance.context.save()
            return true
        } catch  {
            print("Error : csvUtil.loadcsvFile(\(pFile))" )
            return false
        }
    }

 static func csvToAgencys(pCsvAgencys  : [[String]]) -> [Agency] {
    var wAgencys:[Agency] = []
    for agency in pCsvAgencys {
        if  let wAgency    = csvToAgency(pCsvAgency: agency)  {
            wAgencys.append(wAgency)
        }
    }
   return wAgencys
 }
 
 static func csvToAgency(pCsvAgency : [String]!) -> Agency?{
    if  pCsvAgency.count == 6     {
        return  Agency(pAgencyId: pCsvAgency[0], pAgencyName: pCsvAgency[1] )
    }
    return nil

 }
 
 
 
 static func csvToRoutes(pCsvRoutes : [[String]]) -> [Routes] {
    var wRoutes:[Routes] = []
    for route in pCsvRoutes {
        if  let wRoute   = csvToRoute(pCsvRoute: route)  {
            wRoutes.append(wRoute)
        }
    }
    return wRoutes
 }
 
 static func csvToRoute(pCsvRoute : [String]!) -> Routes?{
    do{
        if  pCsvRoute.count == 7 ,
            let id   = try Int16(pCsvRoute[0])   {
            return  Routes(pAgencyId: pCsvRoute[1], pId: id, pName: pCsvRoute[3], pType: pCsvRoute[4]  )
        }
        return nil
    } catch {
        return nil
    }
 }
 
 
 /*
 static func csvToCalenders(pCsvCalenders  : Data!) -> [Calender] {
 
 }
 
 static func csvToCalender(pCsvCalender : Data!) -> Calender?{
 
 }
 
 
 static func csvToTrips(pCsvTrips : Data!) -> [Trips] {
 
 }
 
 static func csvToTrip(pCsvTrip : Data!) -> Trips?{
 
 }
 
 
 
 static func csvToShapes(pCsvShapes : Data!) -> [Shape] {
 
 }
 
 static func csvToShape(pCsvShape : Data!) -> Shape?{
 
 }
 
 
 static func csvToStopTimes(pCsvStopTimes : Data!) -> [StopTimes] {
 
 }
 
 static func csvToStopTime(pCsvStopTime : Data!) -> StopTimes?{
 
 }
 
 
 
 static func csvToStopStops(pCsvStops : Data!) -> [Stops] {
 
 }
 
 static func csvToStopStop(pCsvStop : Data!) -> Stops?{
 
 }
 */


}
