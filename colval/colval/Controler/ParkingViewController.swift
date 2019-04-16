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
    var mapRentParking:[String?: [String?]]   = [:]
    var mapRent:[String:Rent]             = [:]
    var mapParking:[String:Parking]       = [:]
    
    var parkingLoaded = false
    var rentLoaded = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAvleSpaces.text = "Loading"
        
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
        
        let dateStart = Util.strToDate(pDate: "2017-01-01T16:45:00.000Z")
        let dateEnd  = Util.strToDate(pDate:"2019-12-12T16:45:00.000Z")
        
        dc.getRentsForTimeRange(pStart: dateStart, pEnd: dateEnd) { rents in
            
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
     *  Make 2 maps in order to easily retrieve a Parking or Rent by ID
     *  Make a 3rd maps rents by parking by merging the Parkings and Rents
     */
    func mapingRentParking()   {
        // only when both request responce has arrived
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
            mapRent    =  [String: Rent]()
            for rent in arrayRent{
                mapRent[rent.ID!] = rent
            }
            mapParking =  [String: Parking]()
            for parking in arrayParking{
                mapParking[parking.id!] = parking
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
     *  On click anotation
     */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let reservCtrl = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "rsvCtrl")
            as? ReservationControler {
            
            if let parkingPinId = view.annotation?.subtitle! {
                reservCtrl.parking =  mapParking[parkingPinId]
                reservCtrl.parkingAvailable =  mapRentParking[parkingPinId] == nil
                self.navigationController?.pushViewController(reservCtrl, animated: true)
                
            }
            
           
        }
    }
}
