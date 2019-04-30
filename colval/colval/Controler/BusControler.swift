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
    @IBOutlet weak var lblNearestStopDistance: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnArrets: UIButton!
    
    var locationManager = CLLocationManager()
    
    private lazy var routeDataSourceProvider = RouteTVControler(pRouteDataManager: RouteDataManager(pRouteType: RouteDataManager.ALL) , pListener: self )
    
    private var  uniqueHeadsign:[String] = Array(Set(["Selectioner une ligne"]))
    private var  headsignPos             = 0
    
    private let greyColor =  UIColor(hex: "7c7c7c")!
    private let blackColor =  UIColor.black
    
    
    private var nearestStop: Stops?   = nil
    private var selectedArrayTrip: [Trips]?  = nil
    private var selectedRoute:Routes? = nil

    private var userLocation:CLLocation =  CLLocation(latitude: DataControler.sharedInstance.colValRegion.center.latitude, longitude: DataControler.sharedInstance.colValRegion.center.longitude)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Route"
        self.tableView.dataSource = routeDataSourceProvider
        self.tableView.delegate = routeDataSourceProvider
        
        setDirectionButton()
        
        self.lblDay.text = ""
        self.lblNearestStopDistance.text = ""
        self.btnArrets.isEnabled = false
        
        self.lblNearestStopDistance.isEnabled = false
        
        self.loadingIndicator.hidesWhenStopped = true
        let labelTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BusControler.tapOnSpecificStop))
        self.lblNearestStopDistance.addGestureRecognizer(labelTapRecognizer)
        self.loadingIndicator.stopAnimating()
        
        
        
         self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() { 
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
    }
    /*
     * RouteTableViewListener
     */
    func didSelectRoute(pRoute  : Routes!)  {
        btnDestPrev.isEnabled = true
        btnDestNext.isEnabled = true
        
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
    
    
    /*
     *
     *  Function mostly is Async as many CoreData.Request are needed to compute
     *  the nearest stop , and it's distance from the user.
     *
     */
    func setNearestStop(pArrayTrips : [Trips] ) {
        
        self.lblNearestStopDistance.text = ""
        self.lblNearestStopDistance.isEnabled = false
        self.loadingIndicator.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            print("setNearestStop")
            var finalArrayStops:[Stops] = []
            
            for trip in pArrayTrips {
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
                self.lblNearestStopDistance.text = "\(self.nearestStop?.name!) \n \(displayDistance) "
                self.loadingIndicator.stopAnimating()
                self.lblNearestStopDistance.isEnabled = true
                
                self.lblNearestStopDistance.isUserInteractionEnabled = true
            }
        }
    }
    
    /*
     *   
     *   Manage user location when moving
     *   https://github.com/GurdevSingh94/SwiftUserLocation
     *   https://www.youtube.com/watch?v=WDrdtdMYgWc
     *
     *  From :  GurdevSingh94/SwiftUserLocation
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation  = locations.last!
    }
    
    @IBAction func btnSeeStop(_ sender: Any) {
        if let busMapVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "busMap")
            as? BusMapViewController {
            print("TODO :  inside ")
         // tap   busMapVC.selectedStop  =  self.nearestStop
            busMapVC.selectedRoute =  self.selectedRoute
            busMapVC.selectedArrayTrip =  self.selectedArrayTrip
            
            self.navigationController?.pushViewController(busMapVC, animated: true)
        }
    }
    
    
    @objc func tapOnSpecificStop(sender:UITapGestureRecognizer) {
        
        
        if let busMapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "busMap")
            as? BusMapViewController {
            print("TODO :  inside ")
            // tap   busMapVC.selectedStop  =  self.nearestStop
          //  busMapVC.selectedRoute =  self.selectedRoute
           // busMapVC.selectedArrayTrip =  self.selectedArrayTrip//
            
            
            print("tap working nearestStop: " , self.nearestStop)
            
            busMapVC.selectedStop  =  self.nearestStop
            
            
            self.navigationController?.pushViewController(busMapVC, animated: true)
        }
        
      
    }
    
    
    
}
