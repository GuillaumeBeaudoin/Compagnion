//
//  ReservationControler.swift
//  ColValCompagnon2
//
//  Created by Alexandre Arsenault on 2019-03-12.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation
import MapKit

class ReservationControler: UIViewController , MKMapViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var lblParking: UILabel!
    @IBOutlet weak var lblCurrent: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    
    
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dc:DataControler  = DataControler.sharedInstance
    
    var curDate:Date      = Date()
    var curHour:Int       = 0
    var curMin:Int        = 0
    
    //Selected Dates
    var dateFrom:Date     = Date()
    var dateTo:Date       = Date()
    
    var minFromDate:Date = Date()
    var maxFromDate:Date = Date()
    
    var minToDate:Date   = Date()
    var maxToDate:Date   = Date()
    
    var parking:Parking?
    var parkingAvailable = false
    var arrayRentForParking: [Rent]    = []
    
    // false = From , True = To
    var selected:Bool    = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.setRegion(dc.colValRegion ,animated: true)
        
        self.mapView.register(ParkingViewController.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        tableView.dataSource = self
        
        if parking != nil {
            lblParking.text = "Parking #\(parking!.numero)"
            let dateStart = Util.dateTimeFromDateHourMin(pDate: Date(), pHour: 7 , pMinute: 00)
            let dateEnd  =  Util.dateTimeFromDateHourMin(pDate: Date(), pHour: 23, pMinute: 00)
            dc.getRentsForParkingForTimeRange(pParkingID: parking!.id! , pStart: dateStart, pEnd: dateEnd ) { rents in
                if rents?.count ?? 0 > 0  {
                    print("count = " + String( rents!.count ) )
                    self.arrayRentForParking = rents!
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
                
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(self.parking!)
                    let parkingRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.parking!.posX, longitude: self.parking!.posY), span: MKCoordinateSpan(latitudeDelta: 0.0001, longitudeDelta: 0.0001))
                    self.mapView.setRegion(parkingRegion ,animated: true)
                    
                }
            }
            
        }
        
        
        lblFrom.isUserInteractionEnabled = true
        lblFrom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReservationControler.tapLblFrom)))
        
        lblTo.isUserInteractionEnabled = true
        lblTo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReservationControler.tapLblTo)))
        
        
        
        self.curHour   = dc.cal.component(.hour, from: curDate)
        self.curMin    = dc.cal.component(.minute, from: curDate)
        
        let minFromMin:Int = Int(floor(Double(self.curMin / 15)) * 15)
        self.minFromDate =  self.dc.cal.date(bySettingHour: self.curHour ,  minute: minFromMin , second: 0,  of: self.curDate)!
        self.maxFromDate =  self.dc.cal.date(bySettingHour: 22,  minute: 45 , second: 0,  of: self.curDate)!
        self.maxToDate   =  self.dc.cal.date(bySettingHour: 23,  minute: 0 , second: 0,  of: self.curDate)!
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        changeSelection()
        updateTimeForLabel(pLabel: lblFrom, pMin: dc.cal.component(.minute, from: minFromDate), pHour: dc.cal.component(.hour, from: minFromDate))
    }
    
    
    
    @objc func tapLblFrom(sender:UITapGestureRecognizer) {
        if selected {
            changeSelection()
        }
    }
    @objc func tapLblTo(sender:UITapGestureRecognizer) {
        if !selected {
            changeSelection()
        }
    }
    
    
    @IBAction func btnFindToutched(_ sender: Any) {
        dc.postRent(pRent: Rent( pRenterID: (DefaultData.sharedInstance.getLocalUser()?.ID!)! , pParkingID: "TODO", dateFrom: dateFrom, dateTo: dateTo))
    }
    
    
    
    /*
     * Called by both arrow
     */
    @IBAction func btnChangeSelection(_ sender: Any) {
        changeSelection()
    }
    
    /*
     * Change the self.selected and adjust DatePicker
     */
    func changeSelection() {
        self.selected = !self.selected
        
        lblCurrent.text   = (self.selected ? "To" : "From")
        btnPrev.isEnabled = (self.selected ?true:false)
        btnNext.isEnabled = (self.selected ?false:true)
        
        // set for FROM
        if !self.selected  {
            self.dateTo   = datePicker.date                  //save TO
            self.datePicker.minimumDate    =  self.minFromDate
            self.datePicker.maximumDate    =  self.dc.cal.date(byAdding: .minute, value: -15, to: self.dateTo) //self.maxFromDate
            self.datePicker.date           =  self.dateFrom //restaure From
        }// set for TO
        else {
            self.dateFrom = datePicker.date                 //save FROM
            self.datePicker.minimumDate    =  self.dc.cal.date(byAdding: .minute, value: 15, to: self.dateFrom)
            self.datePicker.maximumDate    =  self.maxToDate
            self.datePicker.date           =  self.dateTo   //restaure TO
        }
        
    }
    
    /*
     * Called every time the DatePicker value has changed
     */
    @objc func datePickerChanged(picker: UIDatePicker) {
        let hour = dc.cal.component(.hour, from: picker.date)
        let min = dc.cal.component(.minute, from: picker.date)
        updateTimeForLabel(pLabel: (!self.selected ?self.lblFrom:self.lblTo), pMin: min , pHour: hour)
    }
    /*
     *  Set the UILabel
     */
    func updateTimeForLabel( pLabel :UILabel , pMin:Int , pHour:Int) {
        pLabel.text=(pHour<10 ? "0"+String(pHour): String(pHour))+":"+(pMin==0 ? "00": String(pMin))
    }
    
    
    /***************************************************************
     *************************  MapView   **************************
     ***************************************************************/
    
    
    /*
     *  Create anotation
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: "reuseIdentifier")
        }
        annotationView?.image = UIImage(named: (parkingAvailable ? "parking-empty" : "parking-used") )
        annotationView?.canShowCallout = true
        annotationView?.annotation = annotation
        annotationView?.displayPriority = .required
        
        return annotationView
    }
    
    /***************************************************************
     ********************  TableViewControler   ********************
     ***************************************************************/
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRentForParking.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId")!
        
        let hourFrom   = dc.cal.component(.hour  , from: arrayRentForParking[indexPath.row].dateFrom)
        let minuteFrom = dc.cal.component(.minute, from: arrayRentForParking[indexPath.row].dateFrom)
        let fromStr    = (hourFrom<10 ? "0"+String(hourFrom): String(hourFrom))+":"+(minuteFrom==0 ? "00": String(minuteFrom))
        
        let hourTo     = dc.cal.component(.hour  , from: arrayRentForParking[indexPath.row].dateTo)
        let minuteTo   = dc.cal.component(.minute, from: arrayRentForParking[indexPath.row].dateTo)
        let toStr      = (hourTo<10 ? "0"+String(hourTo): String(hourTo))+":"+(minuteTo==0 ? "00": String(minuteFrom))
        
        cell.textLabel?.text = fromStr + " / " + toStr
        cell.textLabel?.backgroundColor = UIColor.red
        
        return cell
    }
}

