//
//  rating.swift
//  JustGo
//
//  Created by Hansa Chen on 5/7/19.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit

class rating: NSObject {
    
    var rating:String = "0"
    var comment:String = "Comment"
    
    init(rating:String,comment:String){
        self.rating = rating
        self.comment = comment
    }

}

