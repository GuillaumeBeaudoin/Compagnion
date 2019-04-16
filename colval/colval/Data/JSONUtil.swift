//
//  JSONUtil.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-09.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation

class JSONUtil {
    
    // serdhfgjhfdzdhmgfdsafgmhdsaghmgfds
    

    /***************************************************************
     *********************  Object -> JSON   ***********************
     ***************************************************************/
    static func objToJson(pObject : Any) -> Data? {
        var  objectJson:Data?
        
        if let wUser = pObject as? User {
            objectJson = userToJson(pUser: wUser)
            
        }
        if let wRent = pObject as? Rent {
            objectJson = rentToJson(pRent: wRent)
        }
        if let wParking = pObject as? Parking {
            objectJson = parkingToJson(pParking: wParking)
        }
        
        return   objectJson
    }

    static func userToJson(pUser : User) -> Data? {
        var  userJson:Data?
        var parm = [String:String]()
        if let wID = pUser.ID {
            parm["_id"] = wID
        }
        parm["DA"] = String(pUser.DA)
        do {
            userJson = try JSONSerialization.data(withJSONObject: parm, options: [] )
        } catch {
            print("error  : DataControler.userToJson()")
        }
        return userJson
    }

    static func rentToJson(pRent : Rent) -> Data? {
        var  rentJson:Data?
        var parm = [String:String]()
        if let wID = pRent.ID {
            parm["id"] = wID
        }
        parm["parkingID"] = pRent.parkingID
        parm["renterID"]  = pRent.renterID
        do {
            rentJson = try JSONSerialization.data(withJSONObject: parm, options: [] )
        } catch {
            print("error  : DataControler.rentToJson()")
        }
        return rentJson
    }

    static func parkingToJson(pParking : Parking) -> Data? {
        var  parkingJson:Data?
        var parm = [String:String]()
        if let wID = pParking.id {
            parm["_id"] = wID
        }
        parm["posX"]   = String(pParking.posX)
        parm["posY"]   = String(pParking.posY)
        parm["numero"] = String(pParking.numero)
        do {
            parkingJson = try JSONSerialization.data(withJSONObject: parm, options: [] )
        } catch {
            print("error  : DataControler.parkingToJson()")
        }
        return parkingJson
    }


    /***************************************************************
     *********************  JSON -> Object   ***********************
     ***************************************************************/
    static func jsonToUser(pJsonUser : Data) -> User? {
        var wUser:User?
        do {
            let JSON = try JSONSerialization.jsonObject(with: pJsonUser, options: [])
            if let array = JSON as? [String: AnyObject] {
                if  let id       = array["ID"] as? String   ,
                    let da = array["deviceID"] as? Int   {
                    wUser = User(pID: id, pDA: da)
                }
            }
            
        } catch {
            print("error  : DataControler.jsonToUser()")
        }
        return wUser
    }

    static func  jsonToUsers(pJsonUsers: Data!) -> [User]? {
        var wUsers:[User] = []
        if let d = pJsonUsers {
            let jsonFile = try? JSONSerialization.jsonObject(with: d, options: [])
            if let json = jsonFile as? [[String: Any]] {
                // parser le json et stocker les données dans le tableau
                for array in json {
                    if  let id    = array["_id"]   as? String ,
                        let da    = array["DA"]    as? Int     {
                        let wUser = User(pID: id, pDA: da )
                        wUsers.append(wUser)
                    }
                }
            }
        }
        return wUsers
    }

    static func jsonToRent(pJsonRent : Data) -> Rent? {
        var wRent:Rent?
        do {
            let JSON = try JSONSerialization.jsonObject(with: pJsonRent, options: [])
            if let array = JSON as? [String: AnyObject] {
                if  let id          = array["id"]        as? String ,
                    let renterID    = array["renterID"]  as? String ,
                    let parkingID   = array["parkingID"] as? String ,
                    let dateFrom    = array["dateFrom"]  as? String ,
                    let dateTo      = array["dateTo"]    as? String {
                    wRent = Rent(pID: id, pRenterID: renterID, pParkingID: parkingID,dateFrom: Util.strToDate(pDate: dateFrom), dateTo: Util.strToDate(pDate: dateTo) )
                }
            }
        } catch let error {
            print("error  : DataControler.jsonToRent()")
            print(error)
            
        }
        return wRent
    }

    static func  jsonToRents(pJsonRents: Data!) -> [Rent]? {
        var wRents:[Rent] = []
        if let d = pJsonRents {
            let jsonFile = try? JSONSerialization.jsonObject(with: d, options: [])
            if let json = jsonFile as? [[String: Any]] {
                // parser le json et stocker les données dans le tableau
                for array in json {
                    if  let id          = array["_id"]       as? String ,
                        let renterID    = array["renterId"]  as? String ,
                        let parkingID   = array["parkingId"] as? String ,
                        let dateFrom    = array["dateFrom"]  as? String ,
                        let dateTo      = array["dateTo"]    as? String {
                        let wRent = Rent(pID: id, pRenterID: renterID, pParkingID: parkingID,dateFrom: Util.strToDate(pDate: dateFrom), dateTo: Util.strToDate(pDate: dateTo) )
                        wRents.append(wRent)
                    }
                }
            }
        }
        return wRents
    }

    static func jsonToParking(pJsonParking : Data!) -> Parking? {
        var wParking:Parking?
        do {
            let JSON = try JSONSerialization.jsonObject(with: pJsonParking, options: [])
            
            if let array = JSON as? [String: Any] {
                if  let id          = array["_id"]         as? String ,
                    let posX        = array["posX"]        as? Double ,
                    let posY        = array["posY"]        as? Double ,
                    let numero      = array["numero"]      as? Int    {
                    wParking = Parking(pID: id, pPosX: posX, pPosY: posY, pNumero: numero)
                }
            }
        } catch let error {
            print("error  : DataControler.jsonToParking()")
            print(error)
            
        }
        return wParking
    }

    static func jsonToParkings(pJsonParkings : Data!) -> [Parking] {
        var wParkings:[Parking] = []
        if let d = pJsonParkings {
            let jsonFile = try? JSONSerialization.jsonObject(with: d, options: [])
            if let json = jsonFile as? [[String: Any]] {
                // parser le json et stocker les données dans le tableau
                for array in json {
                    if  let id          = array["_id"]         as? String ,
                        let posX        = array["posX"]        as? Double ,
                        let posY        = array["posY"]        as? Double ,
                        let numero      = array["numero"]      as? Int    {
                        let wParking = Parking(pID: id, pPosX: posX, pPosY: posY, pNumero: numero)
                        wParkings.append(wParking)
                    }
                }
            }
        }
        return wParkings
    }
    
    static func jsonToAgencys(pJsonParkings : Data!) -> [Agency] {
        
    }
    
    static func jsonToAgency(pJsonParkings : Data!) -> Agency{
        
    }
    
    
    
    static func jsonToRoutes(pJsonParkings : Data!) -> [Routes] {
        
    }
    
    static func jsonToRoutes(pJsonParkings : Data!) -> Routes{
        
    }
    
    
    
    static func jsonToCalenders(pJsonParkings : Data!) -> [Calender] {
        
    }
    
    static func jsonToCalender(pJsonParkings : Data!) -> Calender{
        
    }
    
    
    static func jsonToTrips(pJsonParkings : Data!) -> [Trips] {
        
    }
    
    static func jsonToTrip(pJsonParkings : Data!) -> Trips{
        
    }
    
    
    
    static func jsonToShapes(pJsonParkings : Data!) -> [Shape] {
        
    }
    
    static func jsonToShape(pJsonParkings : Data!) -> Shape{
        
    }
    
    
    static func jsonToStopTimes(pJsonParkings : Data!) -> [StopTimes] {
        
    }
    
    static func jsonToStopTime(pJsonParkings : Data!) -> StopTimes{
        
    }
    
    
    
    static func jsonToStopStops(pJsonParkings : Data!) -> [Stops] {
        
    }
    
    static func jsonToStopStop(pJsonParkings : Data!) -> Stops{
        
    }
    
    
    
    /***************************************************************
     ***********************  GTSF -> INIT   ***********************
     ***************************************************************/
    
    static func loadGtsfToCoreData()  {
        let context = CoreData.init().context
        
        loadJsonFile(pFile: "agency",     pSubdirectory: "SO" , pObject : Agency(context: context)   )
        loadJsonFile(pFile: "routes",     pSubdirectory: "SO" , pObject : Routes(context: context)   )
        loadJsonFile(pFile: "calendar",   pSubdirectory: "SO" , pObject : Calender(context: context) )
        loadJsonFile(pFile: "trips",      pSubdirectory: "SO" , pObject : Trips(context: context)    )
        loadJsonFile(pFile: "shape",      pSubdirectory: "SO" , pObject : Shape(context: context)    )
        loadJsonFile(pFile: "stop_times", pSubdirectory: "SO" , pObject : StopTimes(context: context))
        loadJsonFile(pFile: "stops",      pSubdirectory: "SO" , pObject : Stops(context: context)    )
        
        
        loadJsonFile(pFile: "agency",     pSubdirectory: "PI" , pObject : Agency(context: context)   )
        loadJsonFile(pFile: "routes",     pSubdirectory: "PI" , pObject : Routes(context: context)   )
        loadJsonFile(pFile: "calendar",   pSubdirectory: "PI" , pObject : Calender(context: context) )
        loadJsonFile(pFile: "trips",      pSubdirectory: "PI" , pObject : Trips(context: context)    )
        loadJsonFile(pFile: "shape",      pSubdirectory: "PI" , pObject : Shape(context: context)    )
        loadJsonFile(pFile: "stop_times", pSubdirectory: "PI" , pObject : StopTimes(context: context))
        loadJsonFile(pFile: "stops",      pSubdirectory: "PI" , pObject : Stops(context: context)    )
    }
    
    static func loadJsonFile(pFile: String ,pSubdirectory : String , pObject : Any)  {
        
        if let jsonFileURL = Bundle.main.url(forResource: pFile, withExtension: "json", subdirectory: pSubdirectory) {
            
            let json = try! String(contentsOf: jsonFileURL, encoding: .utf8)
            print(json)
            
            if let wAgency = pObject as? Agency {
                
            }
            if let wRoutes = pObject as? Routes {
            }
            if let wCalender = pObject as? Calender {
            }
            if let wTrips = pObject as? Trips {
            }
            if let wShape = pObject as? Shape {
            }
            if let wStopTimes = pObject as? StopTimes {
            }
            if let wStops = pObject as? Stops {
            }
        } else { fatalError("Error : JSONUtil.loadJsonFile("+pFile+" , "+pSubdirectory+")")
            
        }
    }
    
    static func insertIntoContext(pFile: String ,pSubdirectory : String , pObject : Any)  {
        
        
    
    }
   
    
    
    
    
}

