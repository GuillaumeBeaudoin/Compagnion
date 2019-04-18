//
//  CSVUtil.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-16.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
// @ref https://stackoverflow.com/questions/43295163/swift-3-1-how-to-get-array-or-dictionary-from-csv
// 
/*
 This utility class import the GTSF feed.
 The General Transit Feed Specification has
 been concieved by Google in order to
 stardardize transit data
 
 It map the csv's field to CoreData class
 
 NOTE : only map the *Required GTFS's classes
 
 NiceToHave : do *Optional GTFS's classes
 
 Here is how CSV fields transfer to CoreData
 aka Fields by Class :
 
 
 //////////////////////////////
 /////////// Shapes  //////////
 //////////////////////////////
 /_______/    CSV     /_______/
 0  shape_id
 1  shape_pt_lat
 2  shape_pt_lon
 3  shape_pt_sequence
 4  shape_dist_traveled     
 /_______/ CoreData  /_______/
 shape_id:   Int16
 lat:        Double
 lon:        Double
 sequence:   Int16
 traveled:   Double
 trip:       Trips?          FK
 //////////////////////////////
 //////////////////////////////
 
 
 //////////////////////////////
 ///////// StopTimes  /////////
 //////////////////////////////
 /_______/    CSV     /_______/
 0  trip_id              
 1  arrival_time
 2  departure_time
 3  stop_id
 4  stop_sequence
 5  pickup_type,
 6  drop_off_type,
 7  shape_dist_traveled
 8  timepoint
 /_______/ CoreData  /_______/
 arrival_time:    NSDate?
 departure_time:  NSDate?
 stop_sequence:   Int16
 pickup_type:     Bool
 drop_off_type:   Bool
 traveled:        Double
 timepoint:       Int16
 stop:            NSSet?     FK
 trip:            Trips?     FK
 //////////////////////////////
 //////////////////////////////
 
  
 //////////////////////////////
 //////////// Stop  ///////////
 //////////////////////////////
 /_______/    CSV     /_______/
 0  stop_id
 1  stop_name
 2  stop_lat
 3  stop_lon
 4  zone_id
 5  stop_code
 6  wheelchair_boarding
 /_______/ CoreData  /_______/
 stop_id:       Int32
 stop_name:     String?
 lat:           Double
 lon:           Double
 zonex:         String?
 stop_code:     Int32
 wheelchair_boarding: Bool
 stopTimes:     StopTimes?   FK
 //////////////////////////////
 //////////////////////////////
 
 
 //////////////////////////////
 ////////// Agencys  /////////
 //////////////////////////////
 /_______/    CSV     /_______/
 0  agency_id
 1  agency_name
 2  agency_url
 3  agency_timezone
 4  agency_lang
 5  agency_fare_url
 /_______/ CoreData  /_______/
 agency_id: String?
 agency_name: String?
 agency_timezone: String?
 agency_lang: String?
 agency_fare_url: String?
 routes: NSSet?              FK
 //////////////////////////////
 //////////////////////////////
 
 
 //////////////////////////////
 /////////// Routes  //////////
 //////////////////////////////
 /_______/    CSV     /_______/
 0  route_id
 1  agency_id
 2  route_short_name
 3  route_long_name
 4  route_type
 5  route_color
 6  route_text_color
 /_______/ CoreData  /_______/
 agency_id: String
 route_id: Int16
 route_name: String?
 route_type: String?
 agency: Agency?
 calendars: Calender?
 trips: NSSet?               FK
 //////////////////////////////
 //////////////////////////////
 
 
 //////////////////////////////
 /////////  Calender  /////////
 //////////////////////////////
 /_______/    CSV     /_______/
 0  service_id
 1  monday
 2  tuesday
 3  wednesday
 4  thursday
 5  friday
 6  saturday
 7  sunday
 8  start_date
 9  end_date
 /_______/ CoreData  /_______/
 dayInFunction: String?
 end_date:      NSDate?
 service_id:    Int16
 start_date:    NSDate?
 routes: Routes?             FK
 //////////////////////////////
 //////////////////////////////
 
 //////////////////////////////
 //////////// Trip  ///////////
 //////////////////////////////
 /_______/    CSV     /_______/
 0  route_id
 1  service_id
 2  trip_id
 3  trip_headsign
 4  direction_id
 5  shape_id
 6  trip_short_name
 /_______/ CoreData  /_______/
 direction_id: Int16
 route_id: Int16
 service_id: Int16
 shape_id: Int16
 trip_headsign: Int16
 trip_id: Int16
 trip_short_name: String?
 routes: Routes?             FK
 shapes: NSSet?              FK
 stoptimes: NSSet?           FK
 //////////////////////////////
 //////////////////////////////
 
 
 */
import Foundation

class CSVUtil {
    
    static let sharedInstance = CSVUtil()
   
   
    
    
    
    private init() {
    }
    
    
    /***************************************************************
     **********************  GTSF -> LOADING ***********************
     ***************************************************************/
    
    static func loadGtsfToCoreData() -> Bool {
        
        loadCsvFile(pFile: "so_calendar",   pClass : "Calender" , pAgency:"CITSO")
        loadCsvFile(pFile: "so_agency",     pClass : "Agency"   , pAgency:"CITSO")
        loadCsvFile(pFile: "so_routes",     pClass : "Routes"   , pAgency:"CITSO")
        loadCsvFile(pFile: "so_shapes",     pClass : "Shape"    , pAgency:"CITSO")
        loadCsvFile(pFile: "so_trips",      pClass : "Trips"    , pAgency:"CITSO")
        loadCsvFile(pFile: "so_stops",      pClass : "Stops"    , pAgency:"CITSO")
        loadCsvFile(pFile: "so_stop_times", pClass : "StopTimes", pAgency:"CITSO")
        /*
        loadCsvFile(pFile: "pi_calendar",   pClass : "Calender" , pAgency:"CITPI")
        loadCsvFile(pFile: "pi_agency",     pClass : "Agency"   , pAgency:"CITPI")
        loadCsvFile(pFile: "pi_routes",     pClass : "Routes"   , pAgency:"CITPI")
        loadCsvFile(pFile: "pi_shapes",     pClass : "Shape"    , pAgency:"CITPI")
        loadCsvFile(pFile: "pi_trips",      pClass : "Trips"    , pAgency:"CITPI")
        loadCsvFile(pFile: "pi_stops",      pClass : "Stops"    , pAgency:"CITPI")
        loadCsvFile(pFile: "pi_stop_times", pClass : "StopTimes", pAgency:"CITPI")
        */
        
        return false
    }
    
    static func loadCsvFile(pFile: String , pClass : String , pAgency:String) -> Bool {
        do {
            print("loadCsvFile : LOADING \(pFile)")
            // read the .csv File
            let filepath =  Bundle.main.path(forResource: pFile, ofType: "txt")
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
            
            switch pClass{
                case  "Shape":
                     let wShapes =  csvToShapes(pCsvShapes: arrayObject)
                case  "Stops" :
                     let wStops =  csvToStops(pCsvStops:  arrayObject)
                case  "StopTimes" :
                    let wStopTimes =  csvToStopTimes(pCsvStopTimes:  arrayObject)
                case  "Calender" :
                    let wCalenders =  csvToCalenders(pCsvCalenders: arrayObject)
                case  "Agency" :
                    let wAgencys =  csvToAgencys(pCsvAgencys: arrayObject)
                case  "Routes" :
                    let wRoutes =  csvToRoutes(pCsvRoutes: arrayObject)
                case  "Trips" :
                    let wTrips =  csvToTrips(pCsvTrips: arrayObject  , pAgency : pAgency)
                default:
                print("CSVUtil.loadCsvFile ERROR unknown Class \(pClass)")
            }
            
            try CoreData.sharedInstance.context.save()
            print("loadCsvFile : LOADED \(pFile) ")
            return true
        } catch  {
            print("Error : csvUtil.loadcsvFile(\(pFile))" )
            return false
        }
    }

 static func csvToAgencys(pCsvAgencys  : [[String]] ) -> [Agency] {
    var wAgencys:[Agency] = []
    for agency in pCsvAgencys {
        if  let wAgency    = csvToAgency(pCsvAgency: agency)  {
            wAgencys.append(wAgency)
        }
    }
   return wAgencys
 }
 
 static func csvToAgency(pCsvAgency : [String]! ) -> Agency?{
    if  pCsvAgency.count == 6     {
        return Agency(pAgencyId: pCsvAgency[0], pAgencyName: pCsvAgency[1], pAgencyTimezone: pCsvAgency[3], pAgencyLang: pCsvAgency[4], pAgencyUrl :  pCsvAgency[2] , pAgencyFareUrl :  pCsvAgency[5] )
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
    if  pCsvRoute.count == 7 ,
        let id   =  Int16(pCsvRoute[0])   {
        let route = Routes(pId: id, pAgencyId: pCsvRoute[1], pShortName: pCsvRoute[2], pLongName: pCsvRoute[3], pColor: pCsvRoute[5], pTextColor: pCsvRoute[6], pType: pCsvRoute[4])
        let agency   = CoreData.sharedInstance.getAgencyFromId(pAgencyId: pCsvRoute[1]  )
        if agency != nil {
            agency?.addToRoutes(route)
        }
        return route
    }
    return nil
 }
  
 static func csvToCalenders(pCsvCalenders  : [[String]]) -> [Calender] {
    var wCalenders:[Calender] = []
    for  calender in pCsvCalenders {
        if  let wCalender   = csvToCalender(pCsvCalender: calender) {
            wCalenders.append(wCalender)
        }
    }
    return wCalenders
 }
    
 static func csvToCalender(pCsvCalender : [String]!) -> Calender?{
    if  pCsvCalender.count == 10 ,
        let serviceId     = Int16(pCsvCalender[0])   {
        let dayInFunction = "\(pCsvCalender[1])\(pCsvCalender[2])\(pCsvCalender[3])\(pCsvCalender[4])\(pCsvCalender[5])\(pCsvCalender[6])\(pCsvCalender[7])"
        let startDate = Util.strToDateGTSF(pDate: pCsvCalender![8], pTimeZoneIdentifier: "America/Montreal")
        let endDate = Util.strToDateGTSF(pDate: pCsvCalender![9], pTimeZoneIdentifier: "America/Montreal")
        
        
        return  Calender(pServiceId: serviceId, pDayInFunction: dayInFunction, pStartDate: startDate , pEndDate: endDate )
    }
    return nil
 }
  
 static func csvToTrips(pCsvTrips : [[String]]  , pAgency:String) -> [Trips] {
    var wTrips:[Trips] = []
    for  trip in pCsvTrips {
        if  let wTrip   = csvToTrip(pCsvTrip: trip , pAgency: pAgency ) {
            wTrips.append(wTrip)
        }
    }
    return wTrips
 }
    
 static func csvToTrip(pCsvTrip : [String]! , pAgency:String) -> Trips?{
    if  pCsvTrip.count == 7 {
        let directionId = Int16(pCsvTrip[4])!
        let trip =  Trips(pId: pCsvTrip[2], pServiceId : pCsvTrip[1] , pHeadsign: pCsvTrip[3], pDirectionId: directionId, pShortName: pCsvTrip[6]  )
        let route = CoreData.sharedInstance.getRouteFromId(pRouteId: Int16(pCsvTrip[0]) ,  pAgency : pAgency  )
        if route != nil {
            route?.addToTrips(trip)
        }
        let shape = CoreData.sharedInstance.getShapeFromId(pShapeId: Int32(pCsvTrip[5]) ) 
        if shape != nil {
            trip.addToShapes(NSSet(array: shape!))
        }
        return trip
    }
    return nil
 }
 
    
 static func csvToShapes(pCsvShapes : [[String]]) -> [Shape] {
    var wShapes:[Shape] = []
    for  shape in pCsvShapes {
        if  let wShape   = csvToShape(pCsvShape: shape) {
            wShapes.append(wShape)
        }
    }
    return wShapes
 }
 
 static func csvToShape(pCsvShape : [String]!) -> Shape?{
    if  pCsvShape.count == 5 {
        let id        = Int32(pCsvShape[0])!
        let lat       = Double(pCsvShape[1])!
        let lon       = Double(pCsvShape[2])!
        let sequence  = Int32(pCsvShape[3])!
        let traveled  = Double(pCsvShape[4])!
        return Shape(pId: id, pLat: lat, pLon: lon, pSequence: sequence, pTraveled: traveled )
    }
    return nil
 }
 
 static func csvToStopTimes(pCsvStopTimes : [[String]]) -> [StopTimes] {
    var wStopTimes:[StopTimes] = []
    var i = 0
    for  stopTimes in pCsvStopTimes {
        i = i + 1
        if  let wStopTime   = csvToStopTime(pCsvStopTime: stopTimes) {
            print("stopTimes #\(i)")
            wStopTimes.append(wStopTime)
        }
    }
    return wStopTimes
 }
  
 static func csvToStopTime(pCsvStopTime : [String]!) -> StopTimes?{ 
    if  pCsvStopTime.count == 9 {
        let arrivalTime   = Date()  //date.....
        let departureTime = Date() // date.....
        let pickupType    = pCsvStopTime[5] == "1"
        let dropOffType   = pCsvStopTime[6] == "1"
        
        let stopSequence  = Int16(pCsvStopTime[4])!
        let timepoint     = Int16(pCsvStopTime[8])!
        let traveled      = Double(pCsvStopTime[7])!
        
        let stopTimes =  StopTimes(pArrivalTime: arrivalTime, pDepartureTime: departureTime, pStopSequence: stopSequence, pPickupType: pickupType, pDropOffType: dropOffType, pTraveled: traveled, pTimepoint: timepoint)
        let stop = CoreData.sharedInstance.getStopFromId(pStopId: pCsvStopTime[3])
        if stop != nil {
            stopTimes.addToStop(stop!)
        }
        let trip = CoreData.sharedInstance.getTripFromId(pTripId: pCsvStopTime[0])
        if trip != nil {
            trip!.addToStoptimes(stopTimes)
        }
        return stopTimes
    }
    return nil
 }
    
 static func csvToStops(pCsvStops : [[String]]) -> [Stops] {
    var wStops:[Stops] = []
    for  stop in pCsvStops {
        if  let wStop   = csvToStop(pCsvStop: stop) {
            wStops.append(wStop)
        }
    }
    return wStops
 }
    
 static func csvToStop(pCsvStop : [String]!) -> Stops? {
    if  pCsvStop.count == 7 {
        let lat                 = Double(pCsvStop[2].trimmingCharacters(in: .whitespacesAndNewlines))!
        let lon                 = Double(pCsvStop[3].trimmingCharacters(in: .whitespacesAndNewlines))!
        let wheelchairBoarding  = pCsvStop[6] == "1"
        return Stops(pId: pCsvStop[0], pStopName: pCsvStop[1], pLat: lat, pLon: lon, pZone: pCsvStop[4], pStopCode: pCsvStop[5], pWheelchairBoarding: wheelchairBoarding)
    }
    return nil
 }
    
}
