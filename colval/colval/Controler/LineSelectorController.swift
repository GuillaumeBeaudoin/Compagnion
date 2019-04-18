//
//  LineSelectorController.swift
//  colval
//
//  Created by user150454 on 4/16/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import UIKit

class LineSelectorController: UIViewController {

    
    
   
    @IBOutlet weak var rentBarButton: UIBarButtonItem!
    @IBOutlet weak var buttonRent: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rentBarButton.isEnabled = true
        buttonRent.isEnabled = true
        navigationItem.rightBarButtonItems = [rentBarButton]
    }
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
