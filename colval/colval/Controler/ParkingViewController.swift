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
    var parkingValue:[String:Bool] = [:]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(latitude: 45.2523979, longitude: -74.1324644)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
        
        //self.mapView.mapType = MKMapType.standard
        self.mapView.delegate = self
        self.mapView.setRegion(region,animated: false)
        
       
        
  
        self.mapView.register(ParkingViewController.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
 

        
        let date = Date()
        dc.getRentsForTimeRange(pStart: date, pEnd: date) { rents in
            if rents != nil {
                for rent in rents!{
                    self.parkingValue[rent.parkingID] = true
                }
            } else {
                print ("Error : could not load getRentsForTimeRange()")
            }
        }
        
        self.dc.getParkings(){ parkings in
            if parkings != nil {
                self.mapView.showAnnotations(parkings!, animated: true)
                self.mapView.addAnnotations(parkings!)
            } else {
                print("Error : could not load  getParkings()")
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
        annotationView?.image = UIImage(named: "parking-empty")
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
