//
//  DataControler.swift
//  ColValCompagnon
//
//  Created by Alexandre Arsenault on 2019-02-26.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation


//return static values fro now until DB is done


class DataControler {
    static let sharedInstance = DataControler()
    
    //private let baseURL =  "https://colval.restlet.net:443/v1/"
    private let baseURL =  "https://colval-cbfd.restdb.io/rest/"
    private let session = URLSession.shared
    private let b64Auth:String
    private let xApiKey:String
    
    
    private init() {
        let username = "fvqefvfb"
        let password = "fvqefvfb"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        b64Auth = "Basic \(loginData.base64EncodedString())"
        xApiKey           = "7b29d3c5d1b96232768b7991fcdfd0b1bd571"
        
    }
    
    /***************************************************************
     *********************  Object -> JSON   ***********************
     ***************************************************************/
    func objToJson(pObject : Any) -> Data? {
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
    
    func userToJson(pUser : User) -> Data? {
        var  userJson:Data?
        var parm = [String:String]()
        if let wID = pUser.ID {
            parm["id"] = wID
        }
        parm["deviceID"] = String(pUser.deviceID)
        do {
            userJson = try JSONSerialization.data(withJSONObject: parm, options: [] )
        } catch {
            print("error  : DataControler.userToJson()")
        }
        return userJson
    }
    
    func rentToJson(pRent : Rent) -> Data? {
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
    
    func parkingToJson(pParking : Parking) -> Data? {
        var  parkingJson:Data?
        var parm = [String:String]()
        if let wID = pParking.id {
            parm["id"] = wID
        }
        parm["posX"] = String(pParking.posX)
        parm["posY"] = String(pParking.posY)
        parm["orientation"] = String(pParking.orientation)
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
    func jsonToUser(pJsonUser : Data) -> User? {
        var wUser:User?
        do {
            let JSON = try JSONSerialization.jsonObject(with: pJsonUser, options: [])
            if let array = JSON as? [String: AnyObject] {
                if  let id       = array["ID"]       as? String   ,
                    let deviceID = array["deviceID"] as? String   {
                    wUser = User(pID: id, pDeviceID: deviceID)
                }
            }
            
        } catch {
            print("error  : DataControler.jsonToUser()")
        }
        return wUser
    }
    
    func jsonToRent(pJsonRent : Data) -> Rent? {
        var wRent:Rent?
        do {
            let JSON = try JSONSerialization.jsonObject(with: pJsonRent, options: [])
            if let array = JSON as? [String: AnyObject] {
                if  let id          = array["id"]        as? String ,
                    let renterID    = array["renterID"]  as? String ,
                    let parkingID   = array["parkingID"] as? String ,
                    let dateFrom    = array["dateFrom"]  as? String ,
                    let dateTo      = array["dateTo"]    as? String               {
                    wRent = Rent(pID: id, pRenterID: renterID, pParkingID: parkingID,dateFrom: dateFrom, dateTo: dateTo)
                }
            }
        } catch let error {
            print("error  : DataControler.jsonToRent()")
            print(error)
            
        }
        return wRent
    }
    
    func  jsonToRents(pJsonRents: Data!) -> [Rent]? {
        var wRents:[Rent] = []
        if let d = pJsonRents {
            let jsonFile = try? JSONSerialization.jsonObject(with: d, options: [])
            if let json = jsonFile as? [[String: Any]] {
                // parser le json et stocker les données dans le tableau
                for array in json {
                    if  let id          = array["id"]        as? String ,
                        let renterID    = array["renterID"]  as? String ,
                        let parkingID   = array["parkingID"] as? String ,
                        let dateFrom    = array["dateFrom"]  as? String ,
                        let dateTo      = array["dateTo"]    as? String     {
                        let wRent = Rent(pID: id, pRenterID: renterID, pParkingID: parkingID,dateFrom: dateFrom, dateTo: dateTo)
                        wRents.append(wRent)
                    }
                }
            }
        }
        return wRents
    }
    
    func jsonToParking(pJsonParking : Data!) -> Parking? {
        var wParking:Parking?
        do {
            let JSON = try JSONSerialization.jsonObject(with: pJsonParking, options: [])
            
            if let array = JSON as? [String: Any] {
                if  let id          = array["id"]       as? String     ,
                    let posX        = array["posX"]     as? String     ,
                    let posY        = array["posY"]     as? String     ,
                    let orientation = array["orientation"] as? String  {
                    wParking = Parking(pID: id, pPosX: Int(posX)!, pPosY: Int(posY)!, pOrientation: (orientation == "TRUE"))
                    
                }
            }
        } catch let error {
            print("error  : DataControler.jsonToParking()")
            print(error)
            
        }
        return wParking
    }
    
    func jsonToParkings(pJsonParkings : Data!) -> [Parking] {
        var wParkings:[Parking] = []
        
        if let d = pJsonParkings {
            let jsonFile = try? JSONSerialization.jsonObject(with: d, options: [])
            if let json = jsonFile as? [[String: Any]] {
                // parser le json et stocker les données dans le tableau
                for array in json {
                    if  let id          = array["id"]       as? String     ,
                        let posX        = array["posX"]     as? String     ,
                        let posY        = array["posY"]     as? String     ,
                        let orientation = array["orientation"] as? String  {
                        let wParking = Parking(pID: id, pPosX: Int(posX)!, pPosY: Int(posY)!, pOrientation: (orientation == "TRUE"))
                        wParkings.append(wParking)
                    }
                }
            }
        }
        return wParkings
    }
    
    
    
    
    
    
    
    /***************************************************************
     ***********************  Parking API   ************************
     ***************************************************************/
    func postParking(pParking  : Parking) -> Parking? {
        var wParking:Parking?
        var wRequest =  prepareRequest(pResource: "parking", pMethod: "POST")
        wRequest.httpBody = parkingToJson(pParking: pParking)
        
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wParking = self.jsonToParking(pJsonParking: donnee)
            }
        }
        task.resume()
        return wParking
    }
    
    
    func getParkings() -> [Parking]? {
        var wParkings:[Parking]?
        let wRequest =  prepareRequest(pResource: "parking", pMethod: "GET")
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                
                wParkings = self.jsonToParkings(pJsonParkings: donnee)
            }
        }
        task.resume()
        return wParkings
        
    }
    
    func getParking(pID: String) -> Parking? {
        var wParking:Parking?
        let wRequest =  prepareRequest(pResource: "parking/"+pID, pMethod: "GET")
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wParking = self.jsonToParking(pJsonParking: donnee)
            }
        }
        task.resume()
        return wParking
    }
    
    
    
    
    /***************************************************************
     *************************  USER API   *************************
     ***************************************************************/
    //get
    //put
    //post
    //delete
    
    
    /***************************************************************
     *************************  Rent API   **************************
     ***************************************************************/
    //get
    //put
    //post
    //delete
    
    func getRentsForTime(pStrat: String , pEnd: String) -> [Rent]? {
        var wRents:[Rent]?
        //  +  TODO
        let wRequest =  prepareRequest(pResource: "parking/"        , pMethod: "GET")
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wRents = self.jsonToRents(pJsonRents: donnee)
            }
        }
        task.resume()
        return wRents
    }
    
    func getRentsForParking(pParkingID: String ) -> [Rent]? {
        var wRents:[Rent]?
        //  +  TODO
        let wRequest =  prepareRequest(pResource: "parking/"+pParkingID, pMethod: "GET")
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wRents = self.jsonToRents(pJsonRents: donnee)
            }
        }
        task.resume()
        return wRents
    }
    
    
    func postRent(pRent : Rent) -> Rent? {
        var wRent:Rent?
        var wRequest =  prepareRequest(pResource: "parking", pMethod: "POST")
        wRequest.httpBody = rentToJson(pRent: pRent);
        
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wRent = self.jsonToRent(pJsonRent: donnee)
            }
        }
        task.resume()
        return wRent
    }
    
    
    /**********************  Helper constructor   ***********************/
    
    func prepareRequest(pResource: String ,pMethod: String ) -> URLRequest {
        var wRequest = URLRequest(url: URL( string: self.baseURL+pResource )!)
        wRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //wRequest.setValue(self.b64Auth, forHTTPHeaderField: "Authorization")
        wRequest.addValue(self.xApiKey , forHTTPHeaderField: "x-apikey")
        wRequest.httpMethod = pMethod
        return  wRequest
    }
    
}


