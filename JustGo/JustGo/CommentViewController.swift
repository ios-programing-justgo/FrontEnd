//
//  CommentViewController.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/7.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CommentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var submitReviewButton: UIButton!


    var commentArr = [rating]()
    var currentStore:String = "0"
    
    struct uploadReview {
        var starRating: String
        var comment: String
        var count: String
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("number of comments: \(commentArr.count)")

        if commentArr.count > 0 {
            currentStore = commentArr[0].count
        }
        
    }

    @IBAction func submitPressed(_ sender: Any) {
        let ref = Database.database().reference().child(currentStore).child("Ratings")
        let temp = uploadReview(starRating: scoreTextField.text!, comment: commentTextField.text!, count: currentStore)
        ref.setValue(temp)
        self.tableView.reloadData()
        
    }
}


extension CommentViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return commentArr.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        let rating: rating

        rating = commentArr[indexPath.row]
        print(rating.rating,rating.comment)
        print()

        cell.setItem(rating: rating)
        return cell
    }
}
