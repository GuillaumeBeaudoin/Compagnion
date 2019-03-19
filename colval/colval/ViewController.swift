//
//  ViewController.swift
//  ColValCompagnon2
//
//  Created by Alexandre Arsenault on 2019-02-26.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dc  = DataControler.sharedInstance
        
        let parking = dc.getParking(pID: "753db5d0-3efc-11e9-844e-2b2f088855a7")
        print( parking?.orientation ?? "default value" )
        
        
        //let parkings = dc.getParkings()
        //print( parkings?[0].orientation ?? "default values" )
        
        
        
        
        
    }


}

