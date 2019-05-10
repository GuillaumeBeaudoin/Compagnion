//
//  ViewController.swift
//  ColValCompagnon2
//
//  Created by Alexandre Arsenault on 2019-02-26.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController,  RouteTVControlerListener , CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var busMapVC:BusMapViewController? = nil
    
    
    
    /*
     private var selectedRoute:Routes? = nil
     private var nearestStop: Stops?   = nil
     private var selectedArrayTrip: [Trips]?  = nil
     private var  uniqueHeadsign:[String] = Array(Set(["Selectioner une ligne"]))
     private var  headsignPos           = 0
     
     
     private var userLocation:CLLocation =  CLLocation(latitude: DataControler.sharedInstance.colValRegion.center.latitude, longitude: DataControler.sharedInstance.colValRegion.center.longitude)
     */
    
    private lazy var routeDataSourceProvider = RouteTVControler(pRouteDataManager: RouteDataManager(pRouteType: RouteDataManager.FAVORITE) , pListener: self )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        
        //let dc  = DataControler.sharedInstance
        let user = DefaultData.sharedInstance.getLocalUser()
        
        if user != nil  {
            print("user logged in as : \( String(user!.DA) )" )
            
            self.tableView.dataSource = routeDataSourceProvider
            self.tableView.delegate = routeDataSourceProvider
            
        } else {
            let sb = UIStoryboard(name: "Main", bundle: Bundle.main )
            
            guard let loginVC = sb.instantiateViewController(withIdentifier: "loginVC") as? LoginViewControler else {
                print("Error : ViewController : Could not initiate segue")
                return
            }
            navigationController?.pushViewController(loginVC, animated: true)
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CoreData.sharedInstance.isGTSFLoaded() == false {
            print("GTSF not detected in core data, importing..." )
            let ok = CSVUtil.loadGtsfToCoreData()
            print("loadCSVFile has  : \(ok)" )
            
        }
        //CoreData.sharedInstance.printAllTripFromId()
        routeDataSourceProvider = RouteTVControler(pRouteDataManager: RouteDataManager(pRouteType: RouteDataManager.FAVORITE) , pListener: self )
        self.tableView.dataSource = routeDataSourceProvider
        self.tableView.delegate = routeDataSourceProvider
    }
    
    /*
     * RouteTableViewListener -->  BusMapViewController
     */
    func didSelectRoute(pRoute  : Routes!)  {
        if let busMapVC2 = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "busMap") as? BusMapViewController {
            
            self.navigationController?.pushViewController(busMapVC2, animated: true)
            busMapVC2.destCont?.setRoute(pRoute: pRoute )
        }
    }
    
    
    
    
    /*
     func getAllHeadSign(pRoute  : Routes!){
     
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
     
     var arrayTrips = CoreData.sharedInstance.getTripFromHeadsign(pHeadsign: uniqueHeadsign[self.headsignPos])
     
     self.selectedArrayTrip = arrayTrips!
     setNearestStop(pArrayTrips: arrayTrips!)
     }
     
     
     
     func setNearestStop(pArrayTrips : [Trips] ) {
     
     
     var finalArrayStops:[Stops] = []
     
     for trip in pArrayTrips {
     let stopTimes : [StopTimes] = trip.stoptimes!.toArray()
     for stopTime in stopTimes {
     let arrayStops = CoreData.sharedInstance.getStopFrom(pStopTimes: stopTime )
     
     
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
     var distance = self.userLocation.distance(from :location)
     if smallestDistance == nil || distance < smallestDistance {
     nearestLocation = location
     smallestDistance = distance
     }
     }
     self.nearestStop =  CoreData.sharedInstance.getStopFrom(pCoordinate: nearestLocation.coordinate)
     }
     
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     self.userLocation  = locations.last!
     }
     */
    
}

