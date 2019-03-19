//
//  ParkingViewController.swift
//  ColValCompagnon2
//
//  Created by user150454 on 3/18/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import UIKit
import MapKit
class ParkingViewController: UIViewController {


    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(latitude: 45.2523979, longitude: -74.1324644)
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005))
        
        self.mapView.setRegion(region,animated: true)
        
        
        let pin1 = pin( pinTitle:"test", pinSubtible: "tes 2 ", location: location )
        
        self.mapView.addAnnotation(pin1)
        
        
        
        
    }//https://www.youtube.com/watch?v=Tt-cIKKuCGA
    


}
