//
//  HomeTableCell.swift
//  PomeloPickUp
//
//  Created by Nilesh on 19/08/20.
//  Copyright © 2020 Nilesh. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

typealias DefaultCallback = (()->())

class HomeTableCell: UITableViewCell {
    
    @IBOutlet var btnSelect: UIButton!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblDistanceWidth: NSLayoutConstraint!
    var selectionCallBack: DefaultCallback?
    
    func setUpCell(model:PickUpInfoModel,isLocationApproved:Bool,currentLocation:CLLocation?,cellIndex:Int,selectedCellIndex:Int?) {
        lblName.text = model.alias == "" ? "No data available" : model.alias
        lblCity.text = model.city == "" ? "No data available" : model.city
        lblAddress.text = model.address1 == "" ? "No data available" : model.address1
        lblDistanceWidth.constant = isLocationApproved ? 48 : 0
        self.layoutIfNeeded()
        if currentLocation != nil && isLocationApproved {
            lblDistance.text = model.distance
        }
        btnSelect.isSelected = cellIndex == selectedCellIndex
    }
    
    @IBAction func btnSelectClicked(_ sender: Any) {
        selectionCallBack?()
    }
    
}
