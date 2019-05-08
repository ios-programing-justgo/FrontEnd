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
    
<<<<<<< HEAD
    struct uploadReview {
        var starRating: String
        var comment: String
        var count: String
    }

=======
>>>>>>> bad7a2f394b6b55d3b0935dde64dffc67597f8bc

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("number of comments: \(commentArr.count)")
<<<<<<< HEAD
        
        print("program started")
        //use Firebase to load data for table


=======


        if commentArr.count > 0 {
            currentStore = commentArr[0].count
        }

>>>>>>> bad7a2f394b6b55d3b0935dde64dffc67597f8bc
    }

    @IBAction func submitPressed(_ sender: Any) {
        let ref = Database.database().reference().child(currentStore).child("Ratings")
        let number = Int.random(in: 0 ..< 100000000)
        let dict : NSDictionary = [ "comment" : commentTextField.text!, "count" : currentStore, "rating" : scoreTextField.text!]
        ref.child(String(number)).setValue(dict)
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
<<<<<<< HEAD
=======


        print(rating.rating,rating.comment)
        print()

>>>>>>> bad7a2f394b6b55d3b0935dde64dffc67597f8bc
        cell.setItem(rating: rating)
        return cell
    }
}
