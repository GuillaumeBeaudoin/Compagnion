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
        self.navigationItem.hidesBackButton = true;
        
        let dc  = DataControler.sharedInstance
        let da = dc.getLocalUser()
        
        if da != nil  {
            print("user logged in as : "+da!)
        } else {
            let sb = UIStoryboard(name: "Main", bundle: Bundle.main )
            
            guard let loginVC = sb.instantiateViewController(withIdentifier: "loginVC") as? LoginViewControler else {
                print("Error : ViewController : Could not initiate segue")
                return
            } 
            navigationController?.pushViewController(loginVC, animated: true)
        }
        
        
    }


}

