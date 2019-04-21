//
//  BusControler.swift
//  ColValCompagnon
//
//  Created by Alexandre Arsenault on 2019-02-26.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//    GTSF Open Data Downloaded as of apl 16 2019 from following :
//
//    CIT Presqu'Ile
//    https://exo.quebec/xdata/citpi/google_transit.zip
//    CIT Sud-Ouest
//    https://exo.quebec/xdata/citso/google_transit.zip

import Foundation


import UIKit
import MapKit
import CoreLocation



class BusControler: UIViewController , RouteTVControlerListener ,  CLLocationManagerDelegate {
    
    
    @IBOutlet weak var tableView:   UITableView!
    @IBOutlet weak var btnDestNext: UIButton!
    @IBOutlet weak var btnDestPrev: UIButton!
    @IBOutlet weak var lblDest:     UILabel!
    @IBOutlet weak var lblDay: UILabel!
    
    private lazy var routeDataSourceProvider = RouteTVControler(pRouteDataManager: RouteDataManager() , pListener: self )
    
    
    private var  uniqueHeadsign:[String] = Array(Set(["Selectioner une ligne"]))
    private var  headsignPos             = 0
    
    private var  userLocation    = CLLocation(latitude: DataControler.sharedInstance.colValRegion.center.latitude , longitude: DataControler.sharedInstance.colValRegion.center.longitude)
    
    private let greyColor =  UIColor(hex: "7c7c7c")
    private let blackColor =  UIColor.black

    
    var myMutableString = NSMutableAttributedString()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Route"
        self.tableView.dataSource = routeDataSourceProvider
        self.tableView.delegate = routeDataSourceProvider
        
        setDirectionButton()
        setDayInFunction(pCalender: [])
    }
    /*
     * RouteTableViewListener
     */
    func didSelectRoute(pRoute  : Routes!)  {
        btnDestPrev.isEnabled = true
        btnDestNext.isEnabled = true
        
        var arrayHeadsign:[String] = []
        var arrayCal:[Calender] = []
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
    
    @IBAction func btnNextTapped(_ sender: Any) {
        self.headsignPos+=1
        setDirectionButton()
    }
    
    @IBAction func btnPrevTapped(_ sender: Any) {
        self.headsignPos-=1
        setDirectionButton()
    }
    
    /*
     *  Adjust the arrow button according to if the user can switch
     *  between (next , prex ) destination from the "uniqueHeadsign" array.
     */
    func setDirectionButton()  {
        let prevEnabled  =  (     self.headsignPos >    0             )
        let nextEnabled  =  ( uniqueHeadsign.count-1 > self.headsignPos )
        
        btnDestPrev.isEnabled = prevEnabled
        btnDestPrev.setTitle(prevEnabled ? "↢":" " , for: .normal)
        btnDestNext.isEnabled = nextEnabled
        btnDestNext.setTitle(nextEnabled ? "↣":" " , for: .normal)
        lblDest.text = uniqueHeadsign[self.headsignPos]
        let arrayTrips = CoreData.sharedInstance.getTripFromHeadsign(pHeadsign: uniqueHeadsign[self.headsignPos])
        if (arrayTrips != nil) {
            setNearestStop(pArrayTrips: arrayTrips!)
        }
    }
    
    /*
     *  Adjust the day display indicator : ( L M M J V S D )
     *  Put the inactive days in gray
     *  From :   https://stackoverflow.com/questions/27728466/use-multiple-font-colors-in-a-single-label
     */
    func setDayInFunction(pCalender : [Calender]) {
        if pCalender.count == 0 {
             lblDay.text = " "
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
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (mondayFinal    ? self.blackColor : self.greyColor ), range: NSRange(location:0 ,length:1))
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (tuesdayFinal   ? self.blackColor : self.greyColor ), range: NSRange(location:2 ,length:1))
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (wednesdayFinal ? self.blackColor : self.greyColor ), range: NSRange(location:4 ,length:1))
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (thursdayFinal  ? self.blackColor : self.greyColor ), range: NSRange(location:6 ,length:1))
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (fridayFinal    ? self.blackColor : self.greyColor ), range: NSRange(location:8 ,length:1))
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (saturdayFinal  ? self.blackColor : self.greyColor ), range: NSRange(location:10,length:1))
            textDayMutable.addAttribute(NSAttributedString.Key.foregroundColor, value: (sundayFinal    ? self.blackColor : self.greyColor ), range: NSRange(location:12,length:1))
             lblDay.attributedText = textDayMutable
        }
    }
    
    
    func setNearestStop(pArrayTrips : [Trips] ) {
        print("setNearestStop")
        var finalArrayStops:[Stops] = []
        
        
        for trip in pArrayTrips {
            let stopTimes : [StopTimes] = trip.stoptimes!.toArray()
            for stopTime in stopTimes {
                let arrayStops = CoreData.sharedInstance.getStopFromStopTime(pStopTimes: stopTime )
                //let stops : [Stops] = stoptimes.stop
                
                for stop in arrayStops! {
                    finalArrayStops.append( stop )
                   // print("stop.name = \(stop.name!)")
                }
            }
        }
        
        let uniqueStops = Array(Set(finalArrayStops))
        //print("uniqueStops.count \(uniqueStops.count)")
        
        var arrayLocation:[CLLocation] = []
        for uStop in uniqueStops {
            arrayLocation.append(CLLocation(latitude: uStop.lat, longitude: uStop.lon))
        }
        var closestLocation: CLLocation!
        var smallestDistance: CLLocationDistance!
        
        for location in arrayLocation {
            let distance = self.userLocation.distance(from :location)
            if smallestDistance == nil || distance < smallestDistance {
                closestLocation = location
                smallestDistance = distance
            }
        }
        
        print("smallestDistance = \(smallestDistance)")
        print("closestLocation = lat/lon \(closestLocation.coordinate.latitude) / \(closestLocation.coordinate.longitude)  )")
        
        
    }
    
    /*
     * Update the location if user move
     * TO TEST , not sure if working..
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations[0] as CLLocation
    }
    
    
}
