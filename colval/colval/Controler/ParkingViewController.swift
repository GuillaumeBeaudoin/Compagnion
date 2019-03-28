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
    @IBOutlet weak var lblAvleSpaces: UILabel!
    
    
    var dc:DataControler  = DataControler.sharedInstance
    
    // true if disponible
    var arrayParking:[Parking]                = []
    var arrayRent: [Rent]                     = []
    var mapRentParking:[String?: [String?]]  = [:]
    
    var parkingLoaded = false
    var rentLoaded = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAvleSpaces.text = "Loading"
        //self.mapView.mapType = MKMapType.standard
        self.mapView.delegate = self
        self.mapView.setRegion(dc.colValRegion ,animated: false)
        
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
     *  compute if a parking is occupied by merging the parking and rents
     */
    func mapingRentParking()   {
        if rentLoaded && parkingLoaded {
            print("mapingRentParking rent=" + String(arrayRent.count) + " parking=" +  String(arrayParking.count)  )
            mapRentParking = [String?: [String?]]()
            for rent in arrayRent {
                if mapRentParking[rent.parkingID] == nil {
                    mapRentParking[rent.parkingID] = [rent.ID!]
                    print("mapingRentParking  new" + rent.ID! )
                } else {
                    mapRentParking[rent.parkingID]! += [rent.ID!]
                    print("mapingRentParking  append")
                }
            }
            
            DispatchQueue.main.async {
                self.lblAvleSpaces.text = String(self.arrayParking.count-self.mapRentParking.count) + "/" + String(self.arrayParking.count) + "parking available"
                self.mapView.addAnnotations(self.arrayParking)
                self.mapView.showAnnotations(self.arrayParking, animated: true)
            }
        }
    }
    
    
    
    /*
     *  Create anotation
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: "reuseIdentifier")
            print("mapView null")
        }
        
                            //fixme  do full validation within that range
        let isAvailable  = mapRentParking[annotation.subtitle!] == nil
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
        if let reservCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rsvCtrl") as? ReservationControler
        {
            reservCtrl.parkingID =  ((view.annotation?.subtitle)!)!
            present(reservCtrl, animated: true, completion: nil)
        }
    }
}
