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
    @IBOutlet weak var btnLogin: UIBarButtonItem!
    
    let dc    = DataControler.sharedInstance
    var intDa:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.setRightBarButton(btnLogin, animated: true)
        
        btnLogin.isEnabled = false
        txtDA.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        txtDA.text = "1247948"
        self.okClick((Any).self)
        
    }
    @IBAction func okClick(_ sender: Any) {
        
        self.setErrText(pText: "Login in progress" )
        btnLogin.isEnabled = false
        lblError.isEnabled = false
        let threadSafeDA   = Int(self.txtDA.text!)!
        
        // verify if exist
        dc.getUserFromDA(pDA:  Int(txtDA.text! )! ) { user in
            print("Login in progress")
            self.setErrText(pText: "Login in progress" )
            if user != nil {
                self.setErrText(pText: "Login Succesful" )
                print("Login Succesful")
                self.dc.setLocalUser(pUser: user!)
                self.performSegue (withIdentifier: "loginToMain", sender: self)
            } else {
                self.setErrText(pText: "User NOT exist, now creating ")
                self.dc.postUser(pUser: User(pDA: threadSafeDA ) ) { user2 in
                    self.dc.getUserFromDA(pDA:  threadSafeDA )  { user3 in
                        // FIXME : not safe, no validation
                        if user3 != nil {
                            self.setErrText(pText: "User created" )
                            self.dc.setLocalUser(pUser: user3! )
                            self.performSegue (withIdentifier: "loginToMain", sender: self)
                        } else {
                            self.setErrText( pText: "Error while trying to login , try again later")
                            DispatchQueue.main.async {
                                self.btnLogin.isEnabled = true
                                self.lblError.isEnabled = true
                            }
                            
                        }
                    }
                }
            }
        } 
    }
    
    func setErrText(pText : String)  {
        DispatchQueue.main.async {
           self.lblError.text = pText
           //print("setErrText = " + pText)
        }
    }
    
    func dismiss()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let ok = textField.text?.count == 7 
        lblError.text = (ok ? "" : "DA not valid" )
        btnLogin.isEnabled = ok
        intDa =  ( ok ?  Int(  textField.text!  ) : -1 )
    }
    
}
