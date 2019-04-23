//
//  BusMapViewController.swift
//  colval
//
//  Created by user150454 on 4/16/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import UIKit
import Foundation
import MapKit


class BusMapViewController: UIViewController , MKMapViewDelegate{

    @IBOutlet weak var busMapView: MKMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var btnFav: UIButton!
    
    var dc  = DataControler.sharedInstance
    var cd  = CoreData.sharedInstance
    
    var selectedRoute:Routes?
    var selectedStop :Stops?
    var selectedArrayTrip : [Trips]?
     
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(selectedArrayTrip)
        
        self.busMapView.delegate = self
        self.busMapView.setRegion(dc.colValLineRegion ,animated: false)
        
        
        
        
        if let wRoute = self.selectedRoute {
            navigationItem.title =  wRoute.route_long_name
            
            
            let isFav = DefaultData.sharedInstance.isLocalFavRoutes(pRouteId: wRoute.route_id)
            let button = UIButton.init(type: .custom)
            button.frame =  CGRect(x: 0, y: 0, width: 44, height: 44)
            button.setImage(UIImage(named: (isFav ? "fav_yes" : "fav_no") ) , for: UIControl.State.normal )
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            view.addSubview(button)
            
            
            let barButton = UIBarButtonItem(customView: view)
            navigationItem.rightBarButtonItem = barButton
            
        }
        if let wStop = self.selectedStop{
            
        }
    }
    
}
