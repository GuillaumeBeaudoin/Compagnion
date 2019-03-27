//
//  ReservationControler.swift
//  ColValCompagnon2
//
//  Created by Alexandre Arsenault on 2019-03-12.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation
import UIKit




//
//  ReservationControler.swift
//  ColValCompagnon2
//
//  Created by Alexandre Arsenault on 2019-03-12.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import UIKit

class ReservationControler: UIViewController {
    
    @IBOutlet weak var lblCurrent: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    
    
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dc:DataControler  = DataControler.sharedInstance
    
    var cal:Calendar = Calendar.current
    
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
    
    // false = From , True = To
    var selected:Bool    = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblFrom.isUserInteractionEnabled = true
        lblFrom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReservationControler.tapLblFrom)))
        
        lblTo.isUserInteractionEnabled = true
        lblTo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReservationControler.tapLblTo)))
        
        
        
        self.curHour   = cal.component(.hour, from: curDate)
        self.curMin    = cal.component(.minute, from: curDate)
        
        let minFromMin:Int = Int(floor(Double(self.curMin / 15)) * 15)
        self.minFromDate =  self.cal.date(bySettingHour: self.curHour ,  minute: minFromMin , second: 0,  of: self.curDate)!
        self.maxFromDate =  self.cal.date(bySettingHour: 22,  minute: 45 , second: 0,  of: self.curDate)!
        self.maxToDate   =  self.cal.date(bySettingHour: 23,  minute: 0 , second: 0,  of: self.curDate)!
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        changeSelection()
        updateTimeForLabel(pLabel: lblFrom, pMin: cal.component(.minute, from: minFromDate), pHour: cal.component(.hour, from: minFromDate))
        
        
        
    }
    
    
    
    @objc func tapLblFrom(sender:UITapGestureRecognizer) {
        print("tapLblFrom")
    }
    @objc func tapLblTo(sender:UITapGestureRecognizer) {
        print("tapLblTo")
    }
    
    
    @IBAction func btnFindToutched(_ sender: Any) {
        dc.postRent(pRent: Rent( pRenterID: (dc.getLocalUser()?.ID!)! , pParkingID: "TODO", dateFrom: dateFrom, dateTo: dateTo))
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
            self.datePicker.maximumDate    =  self.cal.date(byAdding: .minute, value: -15, to: self.dateTo) //self.maxFromDate
            self.datePicker.date           =  self.dateFrom //restaure From
        }// set for TO
        else {
            self.dateFrom = datePicker.date                 //save FROM
            self.datePicker.minimumDate    =  self.cal.date(byAdding: .minute, value: 15, to: self.dateFrom)
            self.datePicker.maximumDate    =  self.maxToDate
            self.datePicker.date           =  self.dateTo   //restaure TO
        }
        
    }
    
    /*
     * Called every time the DatePicker value has changed
     */
    @objc func datePickerChanged(picker: UIDatePicker) {
        print("Change")
        let hour = cal.component(.hour, from: picker.date)
        let min = cal.component(.minute, from: picker.date)
        updateTimeForLabel(pLabel: (!self.selected ?self.lblFrom:self.lblTo), pMin: min , pHour: hour)
    }
    /*
     *  Set the UILabel
     */
    func updateTimeForLabel( pLabel :UILabel , pMin:Int , pHour:Int) {
        pLabel.text=(pHour<10 ? "0"+String(pHour): String(pHour))+":"+(pMin==0 ? "00": String(pMin))
    }
    
}

