//
//  DefaultData.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-04.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation


//
//  Util.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-04.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
import Foundation
/***************************************************************
 *********************** User Default   ************************
 ***************************************************************/
class DefaultData {
    
    static let sharedInstance = DefaultData()
    
    private final let cal:Calendar = Calendar.current
    
    
    
    private final let defaults = UserDefaults.standard
    
    private struct defaultsKeys {
        static let keyID = "userId"
        static let keyDA = "userDA"
    }
    
    private init() {
    }
    
    
    func getLocalUser() -> User? {
        let ID =  defaults.string(forKey: defaultsKeys.keyID)
        let DA =  defaults.string(forKey: defaultsKeys.keyDA)
        var usr:User? = nil
        if ID != nil && DA != nil {
            usr = User(pID: ID!, pDA: Int(DA!)! )
        }
        return usr
    }
    
    func setLocalUser(pUser : User){
        defaults.set(pUser.ID, forKey: defaultsKeys.keyID)
        defaults.set(pUser.DA, forKey: defaultsKeys.keyDA)
    }
    
}
