//
//  RouteTableViewCell.swift
//  colval
//
//  Created by Alexandre Arsenault on 2019-04-19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//

import Foundation 
import UIKit

class RouteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel! 
    @IBOutlet weak var favBtn: UIButton!
    
    
    
    public var route : Routes?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state 
    }
    
    func setFavImage(pIsFav: Bool) {
        self.favBtn.setImage(UIImage(named: (pIsFav ? "fav_yes" : "fav_no") ) , for: UIControl.State.normal )
    }
    
    @IBAction func favBtnClicked(_ sender: Any) {
        print("RouteTableViewCell.favBtnClicked : \(route?.route_id ?? Int16(-1))")
        let isNowFav = DefaultData.sharedInstance.addRemoveLocalFavRoutes(pRouteId: (route?.route_id)! )
        self.setFavImage(pIsFav: isNowFav)
    }
    
    
    
}
