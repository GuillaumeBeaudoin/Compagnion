//
//  RouteTVControler.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
//   Based on  https://medium.com/swift2go/slim-uiviewcontroller-through-uitableview-datasource-delegate-encapsulation-86e88a7cc2ce
//   Alfian Losari   @   https://medium.com/@alfianlosari
//

import Foundation
import UIKit



import UIKit

public class RouteTVControler: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let routeDataManager: RouteDataManager
    private let listener: RouteTVControlerListener
    
    init(pRouteDataManager: RouteDataManager ,  pListener :  RouteTVControlerListener ) {
        self.routeDataManager = pRouteDataManager
        self.listener =  pListener
        super.init()
    }
    
    //MARK: - Table view data source
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeDataManager.routes.count
    }
    
    
     public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {  
        // Table view cells are reused and should be dequeued using a cell identifier.
        
        if self.routeDataManager.type == RouteDataManager.ALL {
            let cellIdentifier = "RouteTableViewCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RouteTableViewCell  else {
                fatalError("The dequeued cell is not an instance of RouteTableViewCell.")
            }
            cell.route = routeDataManager.item(at: indexPath.row)
            let isFav = DefaultData.sharedInstance.isLocalFavRoutes(pRouteId: cell.route!.route_id)
            
            cell.container.backgroundColor =  UIColor(hex:  cell.route!.route_color! ) //?? UIColor.white )
            cell.nameLbl.text              =  cell.route!.route_long_name!
            cell.nameLbl.textColor         =  UIColor(hex: cell.route!.route_text_color!) //?? UIColor.black )
            cell.numberLbl.text            =  String(cell.route!.route_id)
            cell.numberLbl.textColor       =  UIColor(hex: cell.route!.route_text_color!) // ?? UIColor.black )
            cell.setFavImage(pIsFav: isFav)
            return cell
        } else if self.routeDataManager.type == RouteDataManager.FAVORITE {
            let cellIdentifier = "FavRouteTableViewCell"
            guard let favCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavRouteTableViewCell  else {
                fatalError("The dequeued cell is not an instance of FavRouteTableViewCell.")
            }
            favCell.route = routeDataManager.item(at: indexPath.row)
            let isFav = DefaultData.sharedInstance.isLocalFavRoutes(pRouteId: favCell.route!.route_id)
            
            favCell.container.backgroundColor =  UIColor(hex:  favCell.route!.route_color! ) //?? UIColor.white )
            favCell.numberLbl.text            =  String(favCell.route!.route_id)
            favCell.numberLbl.textColor       =  UIColor(hex: favCell.route!.route_text_color!) // ?? UIColor.black )
            favCell.setFavImage(pIsFav: isFav)
            return favCell
        } else {
            //TODO handle error
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ERROR")
        }
     
    }
     
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { 
        self.listener.didSelectRoute(pRoute: routeDataManager.item(at: indexPath.row) )
    }
}

/*
 *  UIColor convenience init  :  Create color from HEX string
 * From :
 *     https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
 *  By :    Paul Hudson   @twostraws 
 */
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        if hex.count == 6 {
            
            //  The black"ish" 1F1F1F chosen by the EXO is dreadfull ,
            //  let's override it with the pretty blue from the Transit app. That blue is lit.
            /*if hex == "1F1F1F" {
                self.init(hex: "162170")
                return
            } else {
            */
                let hexColor = hex+"ff"
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            //}
        }
        return nil
    }
}
