//
//  loginViewControler.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-03-24.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation


//
//  ViewController.swift
//  ColValCompagnon2
//
//  Created by Alexandre Arsenault on 2019-02-26.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import UIKit

class LoginViewControler: UIViewController {
    
    @IBOutlet weak var txtDA: UITextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnOk: UIBarButtonItem!
    
    let dc    = DataControler.sharedInstance
    var txtDa = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.setRightBarButton(btnOk, animated: true)
        
        btnOk.isEnabled = false
        
        txtDA.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    @IBAction func okClicked(_ sender: Any) {
        doneBtnPressed(sender )
    }
    
    @objc func doneBtnPressed(_ sender: Any) {
        print( "Done")
        // verify if exist
        dc.getUserFromDA(pDA:  txtDA.text! )  { user in
            if user != nil {
                print( "User exist")
                self.dc.setLocalUser(pUID: self.txtDa)
            } else {
                self.setErrText(pText: "User NOT exist, now creating ")
                self.dc.postUser(pUser: User(pDA: Int(self.txtDA.text!)!) ) { user in
                    // FIXME : not safe, no validation
                    // if user != nil {
                    self.setErrText(pText:  "User created" )
                    self.dc.setLocalUser(pUID: self.txtDa)
                    self.dismiss()
                    
                    // }
                    // else {  self.lblError.text =  "Error while trying to login , try again later"   }
                    
                }
            }
        }
    }
    
    func setErrText(pText : String)  {
        self.lblError.text = pText
    }
    
    func dismiss()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let ok = textField.text?.count == 7
        txtDa = ( ok ? textField.text! : "")
        lblError.text = (ok ? "" : "DA not valid" )
        btnOk.isEnabled = ok
    }
    
    
}

