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
    static let sharedInstance = BusMapViewController()
    @IBOutlet weak var busMapView: MKMapView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var btnFav: UIButton!
    
    //BusMapViewController.sharedInstance
    static let ID_STOP = "Stop"
    static let ID_NEAREST_STOP = "Nearest Stop"
    
    
    
    var dc  = DataControler.sharedInstance
    var cd  = CoreData.sharedInstance
    
    var selectedRoute:Routes?
    var selectedStop :Stops?
    var selectedArrayTrip : [Trips]?
    var selectedArrayStops : [Stops]?
    var locationManager = CLLocationManager()
    var finalArrayStops:[Stops] = []
    
    private var currentLocation:CLLocation?
    //=  CLLocation(latitude: DataControler.sharedInstance.colValRegion.center.latitude, longitude: DataControler.sharedInstance.colValRegion.center.longitude)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

    //print("Array Trip: ", selectedArrayTrip)
       // print("Array stop: ", selectedStop)
        
        self.busMapView.delegate = self
        self.busMapView.setRegion(dc.colValLineRegion ,animated: false)
        
        let currentRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.2523979, longitude: -74.1324644), span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        
        
        
        
        if let wRoute = self.selectedRoute {
            navigationItem.title =  wRoute.route_long_name
           // print ("array trips : " , wRoute.trips)
            
            
            /*
           wRoute.trips?.forEach { print("test ? ", $0)
                selectedArrayTrip!.append( ($0 as? Trips)! )
            } */
           // wRoute.trips?.forEach { }
         //   selectedArrayTrip?.forEach( {print(" test printing trip : ", $0)})
            
            
            let isFav = DefaultData.sharedInstance.isLocalFavRoutes(pRouteId: wRoute.route_id)
            let button = UIButton.init(type: .custom)
            button.frame =  CGRect(x: 0, y: 0, width: 44, height: 44)
            button.setImage(UIImage(named: (isFav ? "fav_yes" : "fav_no") ) , for: UIControl.State.normal )
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            view.addSubview(button)
            
            
            let barButton = UIBarButtonItem(customView: view)
            navigationItem.rightBarButtonItem = barButton

             busMapView.showsUserLocation=true
        }
        // print( "executign exrta method")
        // print ("selecgted stop : " , self.selectedStop)
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
        self.currentLocation  = locations.last!
        drawDirectionToStopOnTHeMap()
        
    }
    
    
    func drawRouteShape(){
        
    }
    
    
    func allstop()  {
    //   print ("all stop ", selectedArrayTrip)
        
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
                       
                        annotation.subtitle = (stop.wheelchair_boarding ? "♿️":"")
                        annotation.coordinate = CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.lon )

                        
                        busMapView.addAnnotation(annotation)
                    }
                    
                }
            }

        }
        
    }
    
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        busMapView.showsUserLocation=true
        
        if annotation is MKUserLocation {
          /*  let pin = busMapView.view(for: annotation) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.pinTintColor = UIColor.purple*/
            return nil
        }
        
        
        
        let vueAnnotation: MKAnnotationView
        
        if let identifier = mapView.dequeueReusableAnnotationView(withIdentifier: BusMapViewController.ID_STOP) {
            
            identifier.annotation = annotation
            vueAnnotation = identifier
            
        }
        else {
            vueAnnotation = MKPinAnnotationView(annotation: annotation,  reuseIdentifier: BusMapViewController.ID_NEAREST_STOP)
            // change color
        }
        
        
        
        let directionButton = AnotationButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        directionButton.backgroundColor = .green
        directionButton.alpha=0.5
        directionButton.setTitle("GO", for: .normal)
        directionButton.view = annotation as! MKAnnotation
        directionButton.addTarget(self, action: #selector(drawTheDirectionViaPinButton), for: .touchUpInside)
        
        
        
        let alarmButton = AnotationButton(frame: CGRect(x: 100, y: 100, width: 75, height: 50))
        alarmButton.backgroundColor = .green
        alarmButton.alpha=0.5
        alarmButton.setTitle("Alarm", for: .normal)
        alarmButton.view = annotation as! MKAnnotation
        alarmButton.addTarget(self, action: #selector(alarmButtonButton), for: .touchUpInside)
        
        
        vueAnnotation.rightCalloutAccessoryView = directionButton
        vueAnnotation.leftCalloutAccessoryView = alarmButton
 
        vueAnnotation.subviews
        vueAnnotation.canShowCallout = true
        
        return vueAnnotation
        
    }
    
    
    @objc func alarmButtonButton(sender: UIButton, forEvent event: UIEvent) {
        if let button = sender as? AnotationButton {
            print(button.view  )
            
            if let alarmController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "alarmController")
                as? BusAlarmViewController {
                print("TODO :  inside alarmController ")
                
                /*  getAllHeadSign(pRoute: pRoute)
                 
                 
                 alarmController.selectedRoute =  pRoute
                 alarmController.selectedStop = self.nearestStop
                 */
                print("Button tapped", button.view?.title)
                self.navigationController?.pushViewController(alarmController, animated: true)
            }
        }
    }
    
    
    @objc func drawTheDirectionViaPinButton(sender: UIButton, forEvent event: UIEvent) {
        if let button = sender as? AnotationButton {
            print(button.view  )
        
        
            print("Button tapped", button.view?.title)
        
        if let annotationTitle = button.view?.title
        {
            print("User tapped on annotation with title: \(annotationTitle!)")
        }
        
        
        if   ( button.view?.title! != "My Location"){
            self.selectedStop = finalArrayStops.first(where: {($0.name?.elementsEqual(button.view?.title! ?? ""))!})
            drawDirectionToStopOnTHeMap()
            }
        }
        
        
    }

    
    
    func drawDirectionToStopOnTHeMap() {
        
        // set a reset for every time the direction line is called so the new selected pin don't add up to the destination queue
        let overlays = self.busMapView.overlays
        self.busMapView.removeOverlays(overlays)
        
       // print("123456789")
        if let wStop = self.selectedStop , let wLocation = self.currentLocation{
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
            
            var directions = MKDirections(request: request)
            
            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                for route in unwrappedResponse.routes {
                    self.busMapView.addOverlay(route.polyline)
                    self.busMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
 
            }
            
 
            //print("destination qwe: ", wStop.lat , wStop.lon)
            
        }
    }
    
   
    
}
