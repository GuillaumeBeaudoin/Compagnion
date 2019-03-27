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
    private let cal:Calendar = Calendar.current
    private let session = URLSession.shared
    private let baseURL:String  // restdb.io URL
    private let xApiKey:String // restdb.io authentification
    private let defaults = UserDefaults.standard
    
    struct defaultsKeys {
        static let keyID = "userId"
        static let keyDA = "userDA"
    }
    
    private init() {
        baseURL = "https://colval-cbfd.restdb.io/rest/"    // restdb.io URL
        xApiKey = "7b29d3c5d1b96232768b7991fcdfd0b1bd571"
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
            parm["_id"] = wID
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
    
    func  jsonToUsers(pJsonUsers: Data!) -> [User]? {
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
    
    func jsonToRent(pJsonRent : Data) -> Rent? {
        var wRent:Rent?
        do {
            let JSON = try JSONSerialization.jsonObject(with: pJsonRent, options: [])
            if let array = JSON as? [String: AnyObject] {
                if  let id          = array["id"]        as? String ,
                    let renterID    = array["renterID"]  as? String ,
                    let parkingID   = array["parkingID"] as? String ,
                    let dateFrom    = array["dateFrom"]  as? String ,
                    let dateTo      = array["dateTo"]    as? String {
                    wRent = Rent(pID: id, pRenterID: renterID, pParkingID: parkingID,dateFrom: strToDate(pDate: dateFrom), dateTo: strToDate(pDate: dateTo) )
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
                    if  let id          = array["_id"]       as? String ,
                        let renterID    = array["renterId"]  as? String ,
                        let parkingID   = array["parkingId"] as? String ,
                        let dateFrom    = array["dateFrom"]  as? String ,
                        let dateTo      = array["dateTo"]    as? String {
                        let wRent = Rent(pID: id, pRenterID: renterID, pParkingID: parkingID,dateFrom: strToDate(pDate: dateFrom), dateTo: strToDate(pDate: dateTo) )
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
                if  let id          = array["_id"]         as? String ,
                    let posX        = array["posX"]        as? Double ,
                    let posY        = array["posY"]        as? Double ,
                    let orientation = array["orientation"] as? Bool   {
                    wParking = Parking(pID: id, pPosX: posX, pPosY: posY, pOrientation: orientation)
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
                    if  let id          = array["_id"]         as? String ,
                        let posX        = array["posX"]        as? Double ,
                        let posY        = array["posY"]        as? Double ,
                        let orientation = array["orientation"] as? Bool   {
                        let wParking = Parking(pID: id, pPosX: posX, pPosY: posY, pOrientation: orientation)
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
    
    func getParkings(completion: ( ([Parking]?) -> (Void))? ) {
        
        let wRequest =  prepareRequest(pResource: "parking", pMethod: "GET")
        let task = session.dataTask(with: wRequest){ data, _, error in
            var wParkings:[Parking]
            if let donnee = data {
                wParkings = self.jsonToParkings(pJsonParkings: donnee)
                completion?(wParkings)
            }
        }
        task.resume()
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
    //put
    //post
    
    func getUserFromDA(pDA : String , completion: ( (User?) -> (Void))? ) {
        var wUsers:[User]?
        var wUser:User?
        let wRequest =  prepareRequest(pResource: "user", pQuerry: "user?q={\"DA\":\"\(pDA)\"}" , pMethod: "POST" )
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wUsers = self.jsonToUsers(pJsonUsers: donnee)
                if wUsers?.count == 1 {
                    wUser = wUsers![0]
                    completion?(wUser)
                }
            }
        }
        task.resume()
    }
    
    func postUser(pUser : User , completion: ( (User?) -> (Void))? ) {
        var wUser:User?
        var wRequest =  prepareRequest(pResource: "user", pMethod: "POST")
        wRequest.httpBody = userToJson(pUser: pUser);
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wUser = self.jsonToUser(pJsonUser: donnee)
                completion?(wUser)
            }
        }
        task.resume()
    }
    
    
    /***************************************************************
     *************************  Rent API   **************************
     ***************************************************************/
    //get
    //put
    //post
    //delete
    
    /*
     * Return the rents for a dictated range
     *
     *    FIXME : this works (2018-12-31T23:45) , seek if full will also
     *    TODO test if is working
     */
    func getRentsForTimeRange(pStart: Date , pEnd: Date , completion: ( ([Rent]?) -> (Void))? ) {
        var wRents:[Rent]?
        
        
        
        let query = ""
        let wRequest =  prepareRequest(pResource: "rent" , pMethod: "GET")
        let wRequest =  prepareRequest(pResource: "rent", pQuerry: query , pMethod: "POST" )
        
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wRents = self.jsonToRents(pJsonRents: donnee)
                completion?(wRents)
            }
        }
        task.resume()
    }
    
    func getRentsForParkingForTimeRange(pParkingID: String , pStart: Date , pEnd: Date , completion: ( ([Rent]?) -> (Void))? ) {
        var wRents:[Rent]?
        //  +  TODO
        let wRequest =  prepareRequest(pResource: "rent/"+pParkingID, pMethod: "GET")
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wRents = self.jsonToRents(pJsonRents: donnee)
                completion?(wRents)
            }
        }
        task.resume()
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
    
    
    /***************************************************************
     ********************** Helper method   ************************
     ***************************************************************/
    
    
    func prepareRequest(pResource: String ,pMethod: String ) -> URLRequest {
        return prepareRequest(pResource: pResource , pQuerry : nil ,pMethod: pMethod )
    }
    
    /*
     * As all request share the same base request setting ,
     * I created this helper method in order to re-use it
     * dīvide et imperā
     */
    func prepareRequest(pResource: String , pQuerry : String? ,pMethod: String ) -> URLRequest {
        var wRequest:URLRequest
    
        var wUrl:URL! = URL( string: self.baseURL+pResource)
        if pQuerry != nil {
            wUrl = wUrl.append("q", value: pQuerry)
        }
        wRequest = URLRequest(url: wUrl )
        wRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        wRequest.addValue(self.xApiKey , forHTTPHeaderField: "x-apikey")
        wRequest.httpMethod = pMethod
            
        
        return  wRequest
    }
    
    
    
    /*
     * Convert a DT to a DB formated String
     *  YYYY-MM-DDTHH:MM:SS.MLSZ  -> DataBase DateTime formated String
     *  2017-12-10T16:45:00.000Z  -> result example
     */
    func dateToStr(pDate: Date) -> String {
        let year   = cal.component(.year  , from: pDate)
        let month  = cal.component(.month , from: pDate)
        let day    = cal.component(.day   , from: pDate)
        let hour   = cal.component(.hour  , from: pDate)
        let minute = cal.component(.minute, from: pDate)
        
        let monthStr  = ( month  < 10 ? "0" + String(month)  : String(month) )
        let dayStr    = ( day    < 10 ? "0" + String(day)    : String(day)   )
        let hourStr   = ( hour   < 10 ? "0" + String(hour)   : String(hour)  )
        let minuteStr = ( minute < 10 ? "0" + String(minute) : String(minute))
        
        return   String(year) + "-" + monthStr + "-" + dayStr + "T" + hourStr + ":" + minuteStr + ":00.000Z"
        
    }
    
    /*
     * Convert a string DateTime representation to a Date()
     *
     *  YYYY-MM-DDTHH:MM:SS.MLSZ  -> input format
     *  2017-12-10T16:45:00.000Z  -> input example
     *  0  0 00 01 11 11 ignorre  -> substring position (10e1)
     *  0  4 67 90 23 45 ignorre  -> substring position (10e0)
     */
    func strToDate(pDate: String) -> Date {
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "EST") // Eastern Standard Time
        dateComponents.year     = Int(pDate[..<pDate.index(pDate.startIndex, offsetBy: 4)]   )
        dateComponents.month    = Int(pDate[pDate.index(pDate.startIndex, offsetBy: 5)..<pDate.index(pDate.endIndex, offsetBy: -17)])
        dateComponents.day      = Int(pDate[pDate.index(pDate.startIndex, offsetBy: 8)..<pDate.index(pDate.endIndex, offsetBy: -14)]  )
        dateComponents.hour     = Int(pDate[pDate.index(pDate.startIndex, offsetBy: 11)..<pDate.index(pDate.endIndex, offsetBy: -11)]  )
        dateComponents.minute   = Int(pDate[pDate.index(pDate.startIndex, offsetBy: 14)..<pDate.index(pDate.endIndex, offsetBy: -8)]  )
        let dateDate = cal.date(from: dateComponents) ?? Date()
        return  dateDate
    }
    
    
    func getLocalUser() -> User? { 
        let ID =  defaults.string(forKey: defaultsKeys.keyID)
        let DA =  defaults.string(forKey: defaultsKeys.keyDA)
        var usr:User? = nil
        if ID != nil && DA != nil {
            usr = User(pID: ID!, pDA: Int(DA!)! )
        }
        return usr
    }
    
    func setLocalUser(pUser : User){
        defaults.set(pUser.ID, forKey: defaultsKeys.keyID)
        defaults.set(pUser.DA, forKey: defaultsKeys.keyDA)
    }
}

/*
 *   Redefining method for class URL in order to append
 *     querry parameters with rigth encription
 */
extension URL {
    @discardableResult
    func append(_ queryItem: String, value: String?) -> URL {
        
        guard var urlComponents = URLComponents(string:  absoluteString) else { return absoluteURL }
        
        // create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // create query item if value is not nil
        guard let value = value else { return absoluteURL }
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        // append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // append updated query items array in the url component object
        urlComponents.queryItems = queryItems// queryItems?.append(item)
        
        // returns the url from new url components
        return urlComponents.url!
    }
}
