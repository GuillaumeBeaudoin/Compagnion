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
import CoreLocation
import UIKit
import MapKit


class BusRouteViewControler: UIViewController , RouteTVControlerListener, CLLocationManagerDelegate  {
    
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
    
    
    private var destCont : BusDestinationControler?

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Route"
        self.tableView.dataSource = routeDataSourceProvider
        self.tableView.delegate = routeDataSourceProvider
        
        
        destCont = BusDestinationControler(pBtnNext: btnDestNext, pBtnPrev: btnDestPrev, pLblDest: lblDest, pLblDay: lblDay,
                                         pLblNearestStopDistance: lblNearestStopDistance, pActivityIndicator: loadingIndicator)
        
        self.lblDay.text = ""
        self.lblNearestStopDistance.text = ""
        self.btnArrets.isEnabled = false
        
        self.lblNearestStopDistance.isEnabled = false
        
        self.loadingIndicator.hidesWhenStopped = true
        let labelTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BusRouteViewControler.tapOnSpecificStop))
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
     * RouteTableViewListener -> DestinationControler
     */
    func didSelectRoute(pRoute  : Routes!)  {
        destCont!.setRoute(pRoute: pRoute)
    }
   
    
    @IBAction func btnSeeStop(_ sender: Any) {
        if var busMapVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "busMap")
            as? BusMapViewController {
            print("TODO :  inside btnSeeStop")
         // tap   busMapVC.selectedStop  =  self.nearestStop
            //busMapVC.selectedRoute =  self.selectedRoute
            //busMapVC.selectedArrayTrip =  self.selectedArrayTrip
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
             
            // print("tap working nearestStop: " , destCont!.nearestStop)
            
            //busMapVC.selectedStop  =  self.nearestStop
            
            
            self.navigationController?.pushViewController(busMapVC, animated: true)
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
        self.destCont?.setCurrentLocation(pLocation: locations.last! )
    }
    
}

