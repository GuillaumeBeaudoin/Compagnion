//
//  JSONUtil.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-09.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation

class JSONUtil {
    
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
                    wRent = Rent(pID: id, pRenterID: renterID, pParkingID: parkingID,dateFrom: Util.strToDateRest(pDate: dateFrom), dateTo: Util.strToDateRest(pDate: dateTo) )
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
                        let wRent = Rent(pID: id, pRenterID: renterID, pParkingID: parkingID,dateFrom: Util.strToDateRest(pDate: dateFrom), dateTo: Util.strToDateRest(pDate: dateTo) )
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
    
    
    
}

