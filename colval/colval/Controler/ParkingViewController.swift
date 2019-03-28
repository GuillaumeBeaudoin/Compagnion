//
//  ParkingViewController.swift
//  ColValCompagnon2
//
//  Created by user150454 on 3/18/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
import Foundation
import MapKit
class ParkingViewController: UIViewController , MKMapViewDelegate{


    @IBOutlet weak var mapView: MKMapView!
    var dc:DataControler  = DataControler.sharedInstance
    static var staticParkingID: String = ""
    // true if disponible
    var arrayParking:[Parking]                = []
    var arrayRent: [Rent]                     = []
    var mapRentParking:[String?: [String?]]  = [:]
    
    var parkingLoaded = false
    var rentLoaded = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(latitude: 45.2523979, longitude: -74.1324644)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
        
        //self.mapView.mapType = MKMapType.standard
        self.mapView.delegate = self
        self.mapView.setRegion(region,animated: false)
        
       
        
  
        self.mapView.register(ParkingViewController.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
 

        
        
        
        self.dc.getParkings(){ parkings in
            if parkings != nil {
                self.arrayParking = parkings!
                self.parkingLoaded = true
                self.mapingRentParking()
            } else {
                print("Error : could not load : getParkings()")
            }
        }
        
        let date = Date()
        let date2 = dc.strToDate(pDate: "2017-01-01T16:45:00.000Z")
        let date3 = dc.strToDate(pDate: "2019-12-12T16:45:00.000Z")
        
        dc.getRentsForTimeRange(pStart: date2, pEnd: date3) { rents in
            if rents != nil {
                self.arrayRent = rents!
                self.rentLoaded = true
                self.mapingRentParking()
            } else {
                print ("Error : could not load : getRentsForTimeRange()")
            }
        }
        
    }
    
    /*
     *  map the rents by parkings                  [    idParking   , [idRent]    ]
     */
    func mapingRentParking()   {
        if rentLoaded && parkingLoaded {
            print("mapRentParking rent=" + String(arrayRent.count) + " parking=" +  String(arrayParking.count)  )
            mapRentParking = [String?: [String?]]()
            for rent in arrayRent {
                if mapRentParking[rent.parkingID] == nil {
                    mapRentParking[rent.parkingID] = [rent.ID!]
                    print("mapingRentParking  new")
                } else {
                    mapRentParking[rent.parkingID]! += [rent.ID!]
                    print("mapingRentParking  append")
                }
            }
            self.mapView.addAnnotations(arrayParking)
            self.mapView.showAnnotations(arrayParking, animated: true)
        }
    }
    
    
    
    /*
     *  Create anotation
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: "reuseIdentifier")
        }
        
                            //fixme  do full validation within that range
        let isAvailable  = mapRentParking[annotation.subtitle!] == nil
        print("mapView  " + annotation.subtitle!!   + " : " + String(isAvailable) )
        annotationView?.image = UIImage(named: (isAvailable ? "parking-empty" : "parking-used") )
       
        
        annotationView?.canShowCallout = true
        annotationView?.annotation = annotation
        annotationView?.displayPriority = .required
        return annotationView
    }
    /*
     *  On click anotation function
     */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        ParkingViewController.staticParkingID = ((view.annotation?.subtitle)!)!
        
        print (ParkingViewController.staticParkingID)
        performSegue(withIdentifier: "parkingToReservtion", sender: nil)
    }
    
}
