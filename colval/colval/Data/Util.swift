//
//  Util.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-04.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
import Foundation
/***************************************************************
 ********************** Helper method   ************************
 ***************************************************************/
class Util {
    
    static let sharedInstance = Util()
    
    private final let cal:Calendar = Calendar.current
     
    private init() {
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
    
    
    
    
    
    
}
