//
//  Item.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/3.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit

class Item: NSObject {
    var name:String = "No Name"
    var price:String = "0.0"
    var picture:String = "No Pic"
    var storeID:String = "No Store Id."
    var image:UIImage
    
    init(name:String, price:String, picture:String,storeID:String,image:UIImage){
        self.name = name
        self.price = price
        self.picture = picture
        self.storeID = storeID
        self.image = image
    }
    
    func getInfo(){
        print("Name: \(self.name). Price:\(self.price). Picture:\(self.picture). StoreID:\(self.storeID)")
    }
}
