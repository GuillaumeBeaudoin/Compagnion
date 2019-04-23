//
//  ViewController.swift
//  ColValCompagnon2
//
//  Created by Alexandre Arsenault on 2019-02-26.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  RouteTVControlerListener  {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var busMapVC:BusMapViewController? = nil
     private var selectedRoute:Routes? = nil
    
     private lazy var routeDataSourceProvider = RouteTVControler(pRouteDataManager: RouteDataManager(pRouteType: RouteDataManager.FAVORITE) , pListener: self )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        
        //let dc  = DataControler.sharedInstance
        let user = DefaultData.sharedInstance.getLocalUser()
        
        if user != nil  {
            print("user logged in as : \( String(user!.DA) )" )
            
            self.tableView.dataSource = routeDataSourceProvider
            self.tableView.delegate = routeDataSourceProvider
            
        } else {
            let sb = UIStoryboard(name: "Main", bundle: Bundle.main )
            
            guard let loginVC = sb.instantiateViewController(withIdentifier: "loginVC") as? LoginViewControler else {
                print("Error : ViewController : Could not initiate segue")
                return
            } 
            navigationController?.pushViewController(loginVC, animated: true)
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)  
        if CoreData.sharedInstance.isGTSFLoaded() == false {
            print("GTSF not detected in core data, importing..." )
            let ok = CSVUtil.loadGtsfToCoreData()
            print("loadCSVFile has  : \(ok)" )
            
        } 
        //CoreData.sharedInstance.printAllTripFromId()
        routeDataSourceProvider = RouteTVControler(pRouteDataManager: RouteDataManager(pRouteType: RouteDataManager.FAVORITE) , pListener: self )
        self.tableView.dataSource = routeDataSourceProvider
        self.tableView.delegate = routeDataSourceProvider
    }
    
    
    /*
     * RouteTableViewListener
     */
    func didSelectRoute(pRoute  : Routes!)  {
        if let busMapVC2 = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "busMap")
            as? BusMapViewController {
            print("TODO :  inside ")
            busMapVC2.selectedRoute =  pRoute
            self.navigationController?.pushViewController(busMapVC2, animated: true)
        }
    }
    
    


}

