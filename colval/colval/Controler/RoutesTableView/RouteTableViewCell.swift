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
    
    
    public var route : Routes?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state 
    }
    
}
