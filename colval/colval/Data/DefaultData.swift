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
        static let keyFavRoute = "favRoute"
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
    
    func getLocalFavRoutesId() -> [Int16]? {
        return defaults.array(forKey: defaultsKeys.keyFavRoute) as? [Int16]
    }
    
    func setLocalFavRoutesId(pFavRoutesId : [Int16] ){
        defaults.set(pFavRoutesId, forKey: defaultsKeys.keyFavRoute)
    }
    
    /*
     *  Return if the Route is in the favorite
     *
     */
    func isLocalFavRoutes(pRouteId: Int16) -> Bool {
        var found = false
        let arrayFavRoutes = defaults.array(forKey: defaultsKeys.keyFavRoute) as? [Int16]
        if let unwrappedArrayFavRoutes = arrayFavRoutes {
            let setFavRoutes = Set(unwrappedArrayFavRoutes)
            found = setFavRoutes .contains(pRouteId)
        }
        return  found
    }
    
    /*
     *  Add to favorite ( if not favorite )
     *     or
     *  Remove from favorite ( if already favorite
     *
     *  Return the favorite state for that Id after the operation
     */
    func addRemoveLocalFavRoutes(pRouteId: Int16) -> Bool {
        var stateAfter :Bool
        let arrayFavRouteId = self.getLocalFavRoutesId()
        if let unwrappedArrayFavRoutes = arrayFavRouteId {
            var setFavRoutes = Set(unwrappedArrayFavRoutes)
            if setFavRoutes.contains(pRouteId) {
                setFavRoutes.remove(pRouteId)
                stateAfter =  false
            } else {
                setFavRoutes.insert(pRouteId)
                stateAfter = true
            }
            self.setLocalFavRoutesId(pFavRoutesId:  Array(setFavRoutes) )
            return stateAfter
        } else {// no favorite , create first
            self.setLocalFavRoutesId(pFavRoutesId: [pRouteId])
            return true
        }
    }
    
    
}
