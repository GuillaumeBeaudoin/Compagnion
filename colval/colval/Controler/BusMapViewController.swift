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


class BusMapViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var busMapView: MKMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var btnFav: UIButton!
    
    var dc  = DataControler.sharedInstance
    var cd  = CoreData.sharedInstance
    
    var selectedRoute:Routes?
    var selectedStop :Stops?
    var selectedArrayTrip : [Trips]?
    var selectedArrayStops : [Stops]?
     var locationManager = CLLocationManager()
    var finalArrayStops:[Stops] = []
    
    private var userLocation:CLLocation? //=  CLLocation(latitude: DataControler.sharedInstance.colValRegion.center.latitude, longitude: DataControler.sharedInstance.colValRegion.center.longitude)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

      //  print("Array Trip: ", selectedArrayTrip)
        //print("Array stop: ", selectedStop)
        
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
        
        drawDirectionToStopOnTHeMap()
        allstop()

    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 2
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation  = locations.last!
        drawDirectionToStopOnTHeMap()
        
    }
    
    
    func shapDrawing(){
        
    }
    
    
    
    
    
    func allstop()  {
      //  print ("all stop ", selectedArrayTrip)
        
        if var wAllStop = selectedArrayTrip{
            for trip in wAllStop {

                let stopTimes : [StopTimes] = trip.stoptimes!.toArray()
                for stopTime in stopTimes {
                    let arrayStops = CoreData.sharedInstance.getStopFrom(pStopTimes: stopTime )
                    //let stops : [Stops] = stoptimes.stop
                    
                    for stop in arrayStops! {
                        finalArrayStops.append( stop)
                       // print("stop.name = \(stop.lat)")
                        var annotation = MKPointAnnotation()
                        annotation.title = stop.name!
                       
                        annotation.subtitle = stop.name!
                        annotation.coordinate = CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.lon )

                        busMapView.addAnnotation(annotation)
                    }
                }
            }

        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.title
        {
            print("User tapped on annotation with title: \(annotationTitle!)")
        }
        
         
         
        self.selectedStop = finalArrayStops.first(where: {($0.name?.elementsEqual(view.annotation?.title! ?? ""))!})
        
            
        //    view.annotation?.title!!.contains($0.name!))!
         print("pin clicked" , view.annotation?.title!)
        viewDidLoad()
       //  drawDirectionToStopOnTHeMap()
    }
    

    
    
    func drawDirectionToStopOnTHeMap() {
       // print("123456789")
        if let wStop = self.selectedStop , let wLocation = self.userLocation{
           // print("gdfgrgsrthrsthsrth")
            let annotation = MKPointAnnotation()  // <-- new instance here
            annotation.coordinate =  CLLocationCoordinate2D(latitude: wStop.lat, longitude: wStop.lon)
            annotation.title = wStop.name
            busMapView.addAnnotation(annotation)
            
            
            
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D( latitude: wLocation.coordinate.latitude, longitude: wLocation.coordinate.longitude), addressDictionary: nil))
            
            
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: wStop.lat, longitude: wStop.lon), addressDictionary: nil))
            request.requestsAlternateRoutes = true
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            
            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                for route in unwrappedResponse.routes {
                    self.busMapView.addOverlay(route.polyline)
                    self.busMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
 
            }
            
 
            print("destination : ", wStop.lat , wStop.lon)
            
        }
    }
    
   
    
}
