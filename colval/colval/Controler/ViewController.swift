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
     private var selectedRoute:Routes? = nil
    
    
    
    
     private var nearestStop: Stops?   = nil
    private var selectedArrayTrip: [Trips]?  = nil
    private var  uniqueHeadsign:[String] = Array(Set(["Selectioner une ligne"]))
    private var  headsignPos           = 0
       private var userLocation:CLLocation =  CLLocation(latitude: DataControler.sharedInstance.colValRegion.center.latitude, longitude: DataControler.sharedInstance.colValRegion.center.longitude)
    
    
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
     * RouteTableViewListener
     */
    
    
    
    
    
    
    func didSelectRoute(pRoute  : Routes!)  {
        
        if let busMapVC2 = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "busMap")
            as? BusMapViewController {
            print("TODO :  inside didSelectRoute ")
        
        /*btnDestPrev.isEnabled = true
        btnDestNext.isEnabled = true*/
        
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
     //   self.setDayInFunction(pCalender: arrayCal)
        
        setDirectionButton()
            
            busMapVC2.selectedRoute =  pRoute
            
            busMapVC2.selectedStop = self.nearestStop
            print( "nearest :", self.nearestStop)
            self.navigationController?.pushViewController(busMapVC2, animated: true)
        }
            
    }
    
    
    
    func setDirectionButton()  {
        let prevEnabled  =  (     self.headsignPos >    0             )
        let nextEnabled  =  ( uniqueHeadsign.count-1 > self.headsignPos )
        
       
        let arrayTrips = CoreData.sharedInstance.getTripFromHeadsign(pHeadsign: uniqueHeadsign[self.headsignPos])
        if (arrayTrips != nil) {
            setNearestStop(pArrayTrips: arrayTrips!)
            // TODO FINISH
            self.selectedArrayTrip = arrayTrips!
          /* self.btnArrets.isEnabled = true
            self.lblNearestStopDistance.isEnabled = true*/
        }
    }
    
    /*
    func didSelectRoute(pRoute  : Routes!)  {
        
       
        
        if let busMapVC2 = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "busMap")
            as? BusMapViewController {
            print("TODO :  inside didSelectRoute ")
           // pRoute.trips?.forEach({print ("for each trip in rout print : ", $0)})
            
     
          
            
             print("ViewController arrayTrip before: ")
            
    
            
            var arrayHeadsign:[String] = []
           
            self.selectedRoute = pRoute
            
            for trip in pRoute.trips! {
                let trip2  = trip as? Trips
                arrayHeadsign.append(trip2!.headsign!)
            }
            
            self.headsignPos = 0
            self.uniqueHeadsign = Array(Set(arrayHeadsign))
           
            
            let arrayTrips = CoreData.sharedInstance.getTripFromHeadsign(pHeadsign: uniqueHeadsign[self.headsignPos])
            if (arrayTrips != nil) {
                
                // TODO FINISH
               // print("werwerwer : ", arrayTrips!)
                self.selectedArrayTrip = arrayTrips!

            }
            
                print("ViewController arrayTrip after : ", arrayTrips)
            
                setNearestStop(pArrayTrips: arrayTrips!)
            
    
            busMapVC2.selectedRoute =  pRoute
           
           busMapVC2.selectedStop = self.nearestStop
             print( "nearest :", self.nearestStop)
            self.navigationController?.pushViewController(busMapVC2, animated: true)
        }
    }
    
    
   */
    
    
    
    
    func setNearestStop(pArrayTrips : [Trips] ) {

        
        DispatchQueue.global(qos: .userInitiated).async {
            print("setNearestStop")
            var finalArrayStops:[Stops] = []
            
            
            print("setNearestStop" , pArrayTrips )
            for trip in pArrayTrips {
                var stopTimes : [StopTimes] = trip.stoptimes!.toArray()
                for stopTime in stopTimes {
                    var arrayStops = CoreData.sharedInstance.getStopFrom(pStopTimes: stopTime )
                    //let stops : [Stops] = stoptimes.stop
                    
                    for stop in arrayStops! {
                        finalArrayStops.append( stop )
                       // print("stop.name = \(stop.name!)")
                    }
                }
            }
            
            var uniqueStops = Array(Set(finalArrayStops))
            
            var arrayLocation:[CLLocation] = []
            for uStop in uniqueStops {
                //print ("uStop.lat", uStop.lat)
                arrayLocation.append(CLLocation(latitude: uStop.lat, longitude: uStop.lon))
            }
            var nearestLocation: CLLocation!
            var smallestDistance: CLLocationDistance!
            
            for location in arrayLocation {
                var distance = self.userLocation.distance(from :location)
                if smallestDistance == nil || distance < smallestDistance {
                    
                    print("distance ",distance)
                    nearestLocation = location
                   
                }
            }
            
            self.nearestStop =  CoreData.sharedInstance.getStopFrom(pCoordinate: nearestLocation.coordinate)
            print ("self.nearestStop ", self.nearestStop!)
  
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation  = locations.last!
    }

}

