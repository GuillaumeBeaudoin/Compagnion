//
//  DataControler.swift
//  ColValCompagnon
//
//  Created by Alexandre Arsenault on 2019-02-26.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation
import MapKit


//return static values fro now until DB is done


class DataControler {
    
    static let sharedInstance = DataControler()
    private let session = URLSession.shared
    private let baseURL:String  // restdb.io URL
    private let xApiKey:String // restdb.io authentification
    private let defaults = UserDefaults.standard
    
    
    final let cal:Calendar = Calendar.current
    
    final let colValRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.2523979, longitude: -74.1324644), span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
    
    struct defaultsKeys {
        static let keyID = "userId"
        static let keyDA = "userDA"
    }
    
    private init() {
        baseURL = "https://colval-cbfd.restdb.io/rest/"
        xApiKey = "7b29d3c5d1b96232768b7991fcdfd0b1bd571"
    }
    
    
    /***************************************************************
     *************************  USER API   *************************
     ***************************************************************/
    //put
    //post
    
    func getUserFromDA(pDA : Int , completion: ( (User?) -> (Void))? ) {
        var wUsers:[User]?
        var wUser:User?
        let wRequest =  prepareRequest(pResource: "user", pQuerry: "{\"DA\":\(pDA)}" , pMethod: "GET" )
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wUsers = JSONUtil.jsonToUsers(pJsonUsers: donnee)
                if wUsers?.count == 1 {
                    wUser = wUsers![0]
                    completion?(wUser)
                }
            }
            completion?(wUser)
        }
        task.resume()
    }
    
    func postUser(pUser : User , completion: ( (User?) -> (Void))? ) {
        var wUser:User?
        var wRequest =  prepareRequest(pResource: "user", pMethod: "POST")
        wRequest.httpBody = JSONUtil.userToJson(pUser: pUser);
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wUser = JSONUtil.jsonToUser(pJsonUser: donnee)
                completion?(wUser)
            }
        }
        task.resume()
    }
    
    
    
    
    /***************************************************************
     ***********************  Parking API   ************************
     ***************************************************************/
    func postParking(pParking  : Parking) -> Parking? {
        var wParking:Parking?
        var wRequest =  prepareRequest(pResource: "parking", pMethod: "POST")
        wRequest.httpBody = JSONUtil.parkingToJson(pParking: pParking)
        
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wParking = JSONUtil.jsonToParking(pJsonParking: donnee)
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
                wParkings = JSONUtil.jsonToParkings(pJsonParkings: donnee)
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
                wParking = JSONUtil.jsonToParking(pJsonParking: donnee)
            }
        }
        task.resume()
        return wParking
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
        let wRequest =  prepareRequest(pResource: "rent", pQuerry: query , pMethod: "GET" )
        
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wRents = JSONUtil.jsonToRents(pJsonRents: donnee)
                completion?(wRents)
            }
        }
        task.resume()
    }
    
    func getRentsForParkingForTimeRange(pParkingID: String , pStart: Date , pEnd: Date , completion: ( ([Rent]?) -> (Void))? ) {
        var wRents:[Rent]?
        // testme
        let query = "{\"parkingId\":\"\(pParkingID)\",\"dateFrom\":{\"$gt\":{\"$date\":\"\( self.dateToStr(pDate: pStart) )\"}}}"
            
        let wRequest =  prepareRequest(pResource: "rent", pQuerry: query , pMethod: "GET" )
        
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wRents = JSONUtil.jsonToRents(pJsonRents: donnee)
                completion?(wRents)
            }
            completion?(wRents)
        }
        
        task.resume()
    }
    
    
    func postRent(pRent : Rent) -> Rent? {
        var wRent:Rent?
        var wRequest =  prepareRequest(pResource: "parking", pMethod: "POST")
        wRequest.httpBody = JSONUtil.rentToJson(pRent: pRent);
        
        let task = session.dataTask(with: wRequest){ data, _, error in
            if let donnee = data {
                wRent = JSONUtil.jsonToRent(pJsonRent: donnee)
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
    
    
    func dateTimeFromDateHourMin(pDate: Date , pHour: Int , pMinute: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "EST") // Eastern Standard Time
        dateComponents.year     = cal.component(.year  , from: pDate)
        dateComponents.month    = cal.component(.month , from: pDate)
        dateComponents.day      = cal.component(.day  , from: pDate)
        dateComponents.hour     = pHour
        dateComponents.minute   = pMinute
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
