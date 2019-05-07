//
//  RatingCell.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/7.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit

class RatingCell: UITableViewCell {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var rating:[rating]?
    
    func setItem(rating:rating){
        
        scoreLabel.text = rating.rating
        commentLabel.text = rating.comment

        
    }

}
