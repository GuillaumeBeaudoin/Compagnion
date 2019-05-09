//
//  DestinationControler.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-05-07.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class BusDestinationControler {
    
    
    static let sharedInstance = BusMapViewController()
    
    
    private static let COLOR_GREY  =  UIColor(hex: "7c7c7c")!
    private static let COLOR_BLACK =  UIColor.black
    private static let TYPE_ROUTE_SELECT = "type route selector"
    private static let TYPE_MAP = "type map"
    
    
    private var userLocation:CLLocation =  CLLocation(latitude: DataControler.sharedInstance.colValRegion.center.latitude, longitude: DataControler.sharedInstance.colValRegion.center.longitude)
    
    
    var btnNext: UIButton!
    var btnPrev: UIButton!
    var lblDest: UILabel!
    
    var lblDay                 : UILabel?
    var lblNearestStopDistance : UILabel?
    var activityIndicator       : UIActivityIndicatorView?
    
    
    private var  headsignPos           = 0
    private var  uniqueHeadsign:[String] = Array(Set(["Selectioner une ligne"]))
    
    
    public  var selectedArrayTrip: [Trips]?
    public  var selectedRoute:Routes?
    private var nearestStop: Stops?
    private var currentLocation:CLLocation?
    private var type: String
    
    
    
    
    init(pBtnNext: UIButton , pBtnPrev:UIButton,  pLblDest:UILabel) {
        self.type = BusDestinationControler.TYPE_MAP
        self.btnNext = pBtnNext
        self.btnPrev = pBtnPrev
        self.lblDest = pLblDest
        
        init2()
    }
    
    init( pBtnNext: UIButton , pBtnPrev:UIButton                ,  pLblDest:UILabel                            ,
          pLblDay: UILabel   , pLblNearestStopDistance: UILabel ,  pActivityIndicator: UIActivityIndicatorView ) {
        self.type = BusDestinationControler.TYPE_ROUTE_SELECT
        self.btnNext                = pBtnNext
        self.btnPrev                = pBtnPrev
        self.lblDest                = pLblDest
        self.lblDay                 = pLblDay
        self.lblNearestStopDistance = pLblNearestStopDistance
        self.activityIndicator      = pActivityIndicator
        
        
        self.lblDay?.text = ""
        self.lblNearestStopDistance?.text = ""
        self.activityIndicator?.isHidden = true
        
        init2()
    }
    
    
    func init2() {
        btnNext.isEnabled = false
        btnPrev.isEnabled = false
    }
    
    
    
    
    func btnNextTapped() {
        self.headsignPos+=1
        setDirectionButton()
    }
    
    func btnPrevTapped() {
        self.headsignPos-=1
        setDirectionButton()
    }
    
    func setCurrentLocation(pLocation  : CLLocation!)  {
        //TODO update everything
        //setDayInFunction()
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
            self.selectedArrayTrip = arrayTrips!
            setNearestStop()
            //FIXME self.btnArrets.isEnabled = true
            self.lblNearestStopDistance?.isEnabled = true
            
        }
    }
    
    
    
    
    /*
     *  Adjust the day display indicator : ( L M M J V S D )
     *  Put the inactive days in gray
     *
     *  From :   https://stackoverflow.com/questions/27728466/use-multiple-font-colors-in-a-single-label
     */
    func setDayInFunction(pCalender : [Calender]) {
        if pCalender.count == 0 {
            self.lblDay?.text = ""
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
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (mondayFinal    ? BusDestinationControler.COLOR_BLACK : BusDestinationControler.COLOR_GREY ), range: NSRange(location:0 ,length:1))
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (tuesdayFinal   ? BusDestinationControler.COLOR_BLACK : BusDestinationControler.COLOR_GREY ), range: NSRange(location:2 ,length:1))
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (wednesdayFinal ? BusDestinationControler.COLOR_BLACK : BusDestinationControler.COLOR_GREY ), range: NSRange(location:4 ,length:1))
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (thursdayFinal  ? BusDestinationControler.COLOR_BLACK : BusDestinationControler.COLOR_GREY ), range: NSRange(location:6 ,length:1))
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (fridayFinal    ? BusDestinationControler.COLOR_BLACK : BusDestinationControler.COLOR_GREY ), range: NSRange(location:8 ,length:1))
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (saturdayFinal  ? BusDestinationControler.COLOR_BLACK : BusDestinationControler.COLOR_GREY ), range: NSRange(location:10,length:1))
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (sundayFinal    ? BusDestinationControler.COLOR_BLACK : BusDestinationControler.COLOR_GREY ), range: NSRange(location:12,length:1))
            self.lblDay?.attributedText = textDayMutable
        }
    }
    
    
    
    /*
     *
     *  Function mostly is Async as many CoreData.Request are needed to compute
     *  the nearest stop , and it's distance from the user.
     *
     */
    func setNearestStop() {
        self.lblNearestStopDistance?.text = ""
        self.lblNearestStopDistance?.isEnabled = false
        self.activityIndicator?.isHidden = false
        self.activityIndicator?.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            print("setNearestStop")
            var finalArrayStops:[Stops] = []
            
            for trip in self.selectedArrayTrip ?? [] {
                let stopTimes : [StopTimes] = trip.stoptimes!.toArray()
                for stopTime in stopTimes {
                    let arrayStops = CoreData.sharedInstance.getStopFrom(pStopTimes: stopTime )
                    //let stops : [Stops] = stoptimes.stop
                    
                    for stop in arrayStops! {
                        finalArrayStops.append( stop )
                        // print("stop.name = \(stop.name!)")
                    }
                }
            }
            
            let uniqueStops = Array(Set(finalArrayStops))
            
            var arrayLocation:[CLLocation] = []
            for uStop in uniqueStops {
                arrayLocation.append(CLLocation(latitude: uStop.lat, longitude: uStop.lon))
            }
            var nearestLocation: CLLocation!
            var smallestDistance: CLLocationDistance!
            
            //find  nearest stop
            for location in arrayLocation {
                let distance = self.userLocation.distance(from :location)
                if smallestDistance == nil || distance < smallestDistance {
                    nearestLocation = location
                    smallestDistance = distance
                }
            }
            
            self.nearestStop =  CoreData.sharedInstance.getStopFrom(pCoordinate: nearestLocation.coordinate)
            let displayDistance =  ( smallestDistance/1000 < 1 ?
                "\(Int( round( smallestDistance )        ) ) M" :
                "\(Double(round(smallestDistance ) / 1000 ) ) KM" )
            
            // Once all result computed , display on main thread
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
                self.activityIndicator?.isHidden = true
                
                self.lblNearestStopDistance?.text = "\(self.nearestStop?.name!) \n \(displayDistance) "
                self.lblNearestStopDistance?.isEnabled = true
                self.lblNearestStopDistance?.isUserInteractionEnabled = true
            }
        }
    }
}
