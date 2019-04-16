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
        
        self.btnLogin.isEnabled = false
        self.txtDA.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.txtDA.becomeFirstResponder()
        //   testing only
        //txtDA.text = "1247948"
        //self.okClick((Any).self)
        
    }
    @IBAction func okClick(_ sender: Any) {
        
        self.setErrText(pText: "Login in progress" )
        btnLogin.isEnabled = false
        lblError.isEnabled = false
        self.txtDA.resignFirstResponder()
        //let threadSafeDA   = Int(self.txtDA.text!)!
        //guard let threadSafeDA       = textField.text         else { return }
        guard let da  = self.txtDA.text else { return }
        guard let intDa  = Int(da) else { return }
        
        
        
        // Verify if exist
        dc.getUserFromDA(pDA:  Int(txtDA.text! )! ) { user in
            print("Login in progress")
            self.setErrText(pText: "Login in progress" )
            // Exist
            if user != nil {
                self.setErrText(pText: "Login Succesful" )
                print("Login Succesful")
                DefaultData.sharedInstance.setLocalUser(pUser: user!)
                //self.performSegue (withIdentifier: "loginToMain", sender: self)
                self.popMain()
                
            // Create
            } else {
                self.setErrText(pText: "User NOT exist, now creating ")
                self.dc.postUser(pUser: User(pDA: intDa ) ) { user2 in
                    self.dc.getUserFromDA(pDA:  intDa )  { user3 in
                        if user3 != nil {
                            /*guard let user4  = User(from: wdscva) else{
                                self.setErrText( pText: "Error while trying to login , try again later")
                                DispatchQueue.main.async {
                                    self.btnLogin.isEnabled = true
                                    self.lblError.isEnabled = true
                                    self.txtDA.becomeFirstResponder()
                                    return
                                    }*/
                             }
                            self.setErrText(pText: "User created" )
                            DefaultData.sharedInstance.setLocalUser(pUser: user3! )
                            self.popMain()     // user4 )
                        //}
                    }
                }
            }
        } 
    }
    
    func setErrText(pText : String)  {
        DispatchQueue.main.async {
           self.lblError.text = pText
        }
    }
    
    func popMain() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let txtCount = textField.text?.count  else { return }
        DispatchQueue.main.async {
            self.lblError.text =  (txtCount > 7 ? "DA too long" : "" )
            self.btnLogin.isEnabled = txtCount == 7
        }
    }
    
}
