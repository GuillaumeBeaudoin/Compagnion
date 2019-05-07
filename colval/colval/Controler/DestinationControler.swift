//
//  DestinationControler.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-05-07.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import MapKit


class DestinationController {
    static let sharedInstance = BusMapViewController()
    
    
    private let COLOR_GREY  =  UIColor(hex: "7c7c7c")!
    private let COLOR_BLACK =  UIColor.black
    
    var btnNext: UIButton!
    var btnPrev: UIButton!
    var lblDest: UILabel!
    var lblDay: UILabel?
    
    private var  headsignPos           = 0
    private var  uniqueHeadsign:[String] = Array(Set(["Selectioner une ligne"]))
    
    
    private var selectedArrayTrip: [Trips]?  = nil
    private var selectedRoute:Routes? = nil
    private var nearestStop: Stops?   = nil
    
    
    
    private var selectedRoute : Routes?
     
    
    init(pBtnNext: UIButton , pBtnPrev:UIButton,  pLblDest:UILabel) {
        self.btnNext = pBtnNext
        self.btnPrev = pBtnPrev
        self.lblDest = pLblDest
        
         init2()
    }
    
    init(pBtnNext: UIButton , pBtnPrev:UIButton,  pLblDest:UILabel , pLblDay: UILabel) {
        self.btnNext = pBtnNext
        self.btnPrev = pBtnPrev
        self.lblDest = pLblDest
        self.lblDay = pLblDay
        
        init2()
    }
    
    func init2() {
    
        btnNext.isEnabled = false
        btnNext.addTarget(self, action: "btnNextTapped:", for: .touchUpInside)
    
        btnPrev.isEnabled = false
        btnPrev.addTarget(self, action: "btnPrevTapped:", for: .touchUpInside)
    
        //  TODO setDayInFunction(  ..... ) 
    
    }
    
    
    
    @objc func btnNextTapped(_ sender: UIButton) {
        self.headsignPos+=1
        setDirectionButton()
    }
    
    @objc func btnPrevTapped(_ sender: UIButton) {
        self.headsignPos-=1
        setDirectionButton()
    }
    
    func setRoute(pRoute  : Routes!)  {
        btnPrev.isEnabled = true
        btnNext.isEnabled = true
        
        var arrayHeadsign:[String] = []
        var arrayCal:[Calender] = []
        self.selectedRoute = pRoute
        
        for trip in pRoute.trips! {
            let trip2  = trip as? Trips
            let cal  = CoreData.sharedInstance.getCalenderFromId(pCalenderId: trip2?.service_id! ?? "", pAgency: "CITSO")
            arrayCal.append(cal!)
            arrayHeadsign.append(trip2!.headsign!)
        }
        self.headsignPos = 0
        self.uniqueHeadsign = Array(Set(arrayHeadsign))
       
        
        self.setDayInFunction(pCalender: arrayCal)
        
        setDirectionButton()
    }
    
    
    
    /*
     *  Adjust the arrow button according to if the user can switch
     *  between (next , prex ) destination from the "uniqueHeadsign" array.
     */
    func setDirectionButton()  {
        
        let prevEnabled  =  (     self.headsignPos >    0             )
        let nextEnabled  =  ( uniqueHeadsign.count-1 > self.headsignPos )
        
        btnPrev.isEnabled = prevEnabled
        btnPrev.setTitle(prevEnabled ? "↢":" " , for: .normal)
        btnNext.isEnabled = nextEnabled
        btnNext.setTitle(nextEnabled ? "↣":" " , for: .normal)
        lblDest.text = uniqueHeadsign[self.headsignPos]
        
        let arrayTrips = CoreData.sharedInstance.getTripFromHeadsign(pHeadsign: uniqueHeadsign[self.headsignPos])
        if (arrayTrips != nil) {
            setNearestStop(pArrayTrips: arrayTrips!)
            // TODO FINISH
            self.selectedArrayTrip = arrayTrips!
            self.btnArrets.isEnabled = true
            self.lblNearestStopDistance.isEnabled = true
        }
    }
    
    
    
    
    /*
     *  Adjust the day display indicator : ( L M M J V S D )
     *  Put the inactive days in gray
     *
     *  From :   https://stackoverflow.com/questions/27728466/use-multiple-font-colors-in-a-single-label
     */
    func setDayInFunction(pCalender : [Calender]) {
        
        
        if let wLblDay = self.lblDay {
            if pCalender.count == 0 {
                wLblDay.text = " "
            } else {
                var mondayFinal    = false
                var tuesdayFinal   = false
                var wednesdayFinal = false
                var thursdayFinal  = false
                var fridayFinal    = false
                var saturdayFinal  = false
                var sundayFinal    = false
                for cal in pCalender {
                    mondayFinal    = ( cal.monday    ? true : mondayFinal    )
                    tuesdayFinal   = ( cal.tuesday   ? true : tuesdayFinal   )
                    wednesdayFinal = ( cal.wednesday ? true : wednesdayFinal )
                    thursdayFinal  = ( cal.monday    ? true : thursdayFinal  )
                    fridayFinal    = ( cal.friday    ? true : fridayFinal    )
                    saturdayFinal  = ( cal.saturday  ? true : saturdayFinal  )
                    sundayFinal    = ( cal.sunday    ? true : sundayFinal    )
                }
                
                let textDayMutable = NSMutableAttributedString(string: "L M M J V S D", attributes: [NSAttributedString.Key.font :UIFont(name: "Georgia", size: 18.0)!])
                textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (mondayFinal    ? self.COLOR_BLACK : self.COLOR_GREY ), range: NSRange(location:0 ,length:1))
                textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (tuesdayFinal   ? self.COLOR_BLACK : self.COLOR_GREY ), range: NSRange(location:2 ,length:1))
                textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (wednesdayFinal ? self.COLOR_BLACK : self.COLOR_GREY ), range: NSRange(location:4 ,length:1))
                textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (thursdayFinal  ? self.COLOR_BLACK : self.COLOR_GREY ), range: NSRange(location:6 ,length:1))
                textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (fridayFinal    ? self.COLOR_BLACK : self.COLOR_GREY ), range: NSRange(location:8 ,length:1))
                textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (saturdayFinal  ? self.COLOR_BLACK : self.COLOR_GREY ), range: NSRange(location:10,length:1))
                textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (sundayFinal    ? self.COLOR_BLACK : self.COLOR_GREY ), range: NSRange(location:12,length:1))
                wLblDay.attributedText = textDayMutable
            }
        }
    }
    
    
    
}
