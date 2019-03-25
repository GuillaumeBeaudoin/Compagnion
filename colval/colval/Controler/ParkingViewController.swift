//
//  ParkingViewController.swift
//  ColValCompagnon2
//
//  Created by user150454 on 3/18/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import UIKit
import MapKit
class ParkingViewController: UIViewController , MKMapViewDelegate{


    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        
        let location = CLLocationCoordinate2D(latitude: 45.2523979, longitude: -74.1324644)
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
        
        self.mapView.setRegion(region,animated: true)
        
        
        
        self.mapView.delegate = self
  
            let urlWS = URL(string: "https://colval-cbfd.restdb.io/rest/parking")
            var req = URLRequest(url: urlWS!)
            req.httpMethod = "GET"
            req.addValue("7b29d3c5d1b96232768b7991fcdfd0b1bd571", forHTTPHeaderField: "x-apikey")
            let session = URLSession.shared
            session.dataTask(with: req){
                (data, response, error) in
                if let d = data {
                    let jsonFile = try? JSONSerialization.jsonObject(with: d, options: [])
                    if var json = jsonFile as? [[String: Any]] {
                        // parser le json et stocker les données dans le tableau
                        var pin2:pin
                        
                        for item in json {

                            
                            print(item["_id"] as! String)

                            pin2 =   pin(pinTitle:item["_id"] as! String, pinSubTitle: item["_id"] as! String + "test", location: CLLocationCoordinate2D(latitude: item["posX"] as! Double, longitude: item["posY"] as! Double))
                            
                            
                            print (pin2.coordinate)
                            self.mapView.addAnnotation(pin2)
                            
 
                        }

                    }
                }
                }.resume()

    } // didload
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {  // annotation specific
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        annotationView.image = UIImage(named: "parking")
        
        annotationView.canShowCallout = true
        return annotationView
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { // on click function

        print (view.annotation?.title)
        
        //self.navigationController?.pushViewController(ReservationControler, animated: true)
    
    }
    
    
    

}
