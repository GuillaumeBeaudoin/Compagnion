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
    
    
    
    
    private var destCont : DestinationController

    private var userLocation:CLLocation =  CLLocation(latitude: DataControler.sharedInstance.colValRegion.center.latitude, longitude: DataControler.sharedInstance.colValRegion.center.longitude)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Route"
        self.tableView.dataSource = routeDataSourceProvider
        self.tableView.delegate = routeDataSourceProvider
        
        
        destCont = DestinationController(pBtnNext: <#T##UIButton#>, pBtnPrev: <#T##UIButton#>, pLblDest: <#T##UILabel#>, pLblDay: <#T##UILabel#>)
        
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
        destCont.setRoute(pRoute: pRoute)
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
        if var busMapVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "busMap")
            as? BusMapViewController {
            print("TODO :  inside btnSeeStop")
         // tap   busMapVC.selectedStop  =  self.nearestStop
            busMapVC.selectedRoute =  self.selectedRoute
            busMapVC.selectedArrayTrip =  self.selectedArrayTrip
           // busMapVC.selectedArrayStops = self.selectedArrayTri
            self.navigationController?.pushViewController(busMapVC, animated: true)
        }
    }
    
    
    @objc func tapOnSpecificStop(sender:UITapGestureRecognizer) {
        
        
        if var busMapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "busMap")
            as? BusMapViewController {
            print("TODO :  inside tapOnSpecificStop")
            // tap   busMapVC.selectedStop  =  self.nearestStop
          //  busMapVC.selectedRoute =  self.selectedRoute
           // busMapVC.selectedArrayTrip =  self.selectedArrayTrip//
            
            
            print("tap working nearestStop: " , self.nearestStop)
            
            busMapVC.selectedStop  =  self.nearestStop
            
            
            self.navigationController?.pushViewController(busMapVC, animated: true)
        }
        
      
    }
    
    
    
}
