//
//  Util.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-04.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
import Foundation
/***************************************************************
 ********************* Calander Utils   ************************
 ***************************************************************/
class Util {
    
    
    private static let cal:Calendar = Calendar.current
    
    /*
     * Convert a Date to a DB formated String
     *  YYYY-MM-DDTHH:MM:SS.MLSZ  -> DataBase DateTime formated String
     *  2017-12-10T16:45:00.000Z  -> result example
     */
    static func dateToStrRest(pDate: Date) -> String {
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
     * Convert a string DBDateTime representation to a Date
     *
     *  YYYY-MM-DDTHH:MM:SS.MLSZ  -> input format
     *  2017-12-10T16:45:00.000Z  -> input example
     *  0  0 00 01 11 11 ignorre  -> substring position (10e1)
     *  0  4 67 90 23 45 ignorre  -> substring position (10e0)
     */
    static func strToDateRest(pDate: String) -> Date {
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
    
    /*
     * Create a Date a.k.a. DateTime
     * from the time ( pHour & pMinute )
     * using the current day
     */
    static func dateTimeFromDateHourMinRest(pDate: Date , pHour: Int , pMinute: Int) -> Date {
        
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
    // YYYYMMDD
    //20190107,
    //20190113
    
    
    
    /*
     * Convert a DT to a DB formated String
     *  YYYYMMDD  -> GTSG Date formated String
     *  20180317  -> result example
     */
    static func dateToStrGTSF(pDate: Date) -> String {
        let year   = cal.component(.year  , from: pDate)
        let month  = cal.component(.month , from: pDate)
        let day    = cal.component(.day   , from: pDate)
        
        let monthStr  = ( month  < 10 ? "0" + String(month)  : String(month) )
        let dayStr    = ( day    < 10 ? "0" + String(day)    : String(day)   )
        return   String(year) + "-" + monthStr + "-" + dayStr
        
    }
    
    /*
     * Convert a string Date representation to a Date()
     *
     *  YYYYMMDD -> input format
     *  20190317 -> input example
     *  0  4 678 -> substring position (10e0)
     */
    static func strToDateGTSF(pDate: String , pTimeZoneIdentifier: String) -> Date {
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(identifier: pTimeZoneIdentifier)!
        let wYear  =   Int(pDate[..<pDate.index(pDate.startIndex, offsetBy: 4)]   )
        dateComponents.year     = wYear
        let wMonth  = Int(pDate[pDate.index(pDate.startIndex, offsetBy: 4)..<pDate.index(pDate.endIndex, offsetBy: -2)])
        dateComponents.month    = wMonth
        let wDay  =  Int(pDate[pDate.index(pDate.startIndex, offsetBy: 6)..<pDate.index(pDate.endIndex, offsetBy: -0)])
        dateComponents.day      =  wDay
        dateComponents.hour     = 0
        dateComponents.minute   = 0
        let dateDate = cal.date(from: dateComponents) ?? Date()
        return  dateDate
    }
    
    
    //TODO hours   06:45:00
}


