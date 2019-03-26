//
//  ParkingViewController.swift
//  ColValCompagnon2
//
//  Created by user150454 on 3/18/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
import Foundation
import UIKit
import MapKit
class ParkingViewController: UIViewController , MKMapViewDelegate{


    @IBOutlet weak var mapView: MKMapView!
    var dc:DataControler  = DataControler.sharedInstance

    // true if disponible
    var parkingValue:[String:Bool] = [:]

    
   
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let date = Date()
       // let dateEnd = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        
        dc.getRentsForTimeRange(pStart: date, pEnd: date) { rents in
            if rents != nil {
            for rent in rents!{
                
            
                self.parkingValue[rent.parkingID] = true
            }
            }else {print ("missing in parking controller")}
            
        }
        
      
        let location = CLLocationCoordinate2D(latitude: 45.2523979, longitude: -74.1324644)
       
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
        
        self.mapView.setRegion(region,animated: false)
        
        
        
        self.mapView.delegate = self
  
            let urlWS = URL(string: "https://colval-cbfd.restdb.io/rest/parking")
            var req = URLRequest(url: urlWS!)
            req.httpMethod = "GET"
            req.addValue("7b29d3c5d1b96232768b7991fcdfd0b1bd571", forHTTPHeaderField: "x-apikey")
            let session = URLSession.shared
            session.dataTask(with: req){
                (data, response, error) in
                
                dc.getParkings(){ parkings in
                    if parkings != nil {
                        for parking in parkings! {
                            self.mapView.addAnnotation(parking)
                            
                        }
                        
                    } else {
                        print("could not loas parkings")
                    }
                    
                    
                }
        
        
        
        
    } // didload
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {  // annotation specific
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
       
        
        
        annotationView.image = UIImage(named: "parking-empty")
        
        
        
        
        
        annotationView.canShowCallout = true
        return annotationView
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { // on click function

        print (view.annotation?.title)
        
        
        
performSegue(withIdentifier: "sendingParkingId", sender: nil)

        //self.navigationController?.pushViewController(ReservationControler, animated: true)
    
    }
    
    
    

}
