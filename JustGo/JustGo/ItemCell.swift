//
//  ItemCell.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/5.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    //@IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var storeLocationLabel: UILabel!
    
    func setItem(item:Item){
        //setting img
        ////itemImageView.image = item.picture
        
        itemNameLabel.text = item.name
        itemPriceLabel.text = item.price
        itemImageView.image = item.image
        
        for store in storeArr{
            if store.storeID == item.storeID{
                storeLocationLabel.text = store.address
            
            }
        }
        
        
    }

    
}
