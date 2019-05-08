//
//  CommentViewController.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/7.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit
import FirebaseDatabase

var reviewArr = [rating]()

class CommentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var submitReviewButton: UIButton!


    var inputCount:String?
    var currentStore:String = "0"


    override func viewDidLoad() {
        super.viewDidLoad()

        let ref = Database.database().reference().child(inputCount!).child("Ratings")
            ref.observe(.value) { (snapshot) in
                reviewArr = []
                for eachReview in snapshot.children.allObjects as! [DataSnapshot] {
                    let reviewObject = eachReview.value as? [String: AnyObject]
                    let reviewStar = reviewObject?["rating"]
                    let reviewComment = reviewObject?["comment"]
                    let reviewCount = reviewObject?["count"]
                    let new_Review = rating(rating: reviewStar as! String, comment: reviewComment as! String, count:reviewCount as! String )
                    reviewArr.append(new_Review)
                    self.tableView.reloadData()
                    }
                print("hello \(reviewArr.count)")
                if reviewArr.count > 0 {
                    self.currentStore = reviewArr[0].count
                }
            }


    }

    @IBAction func submitPressed(_ sender: Any) {
        let ref = Database.database().reference().child(currentStore).child("Ratings")
        let number = Int.random(in: 0 ..< 100000000)
        let dict : NSDictionary = [ "comment" : commentTextField.text!, "count" : currentStore, "rating" : scoreTextField.text!]
        ref.child(String(number)).setValue(dict)
//        self.tableView.reloadData()

    }
}


extension CommentViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return reviewArr.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        let rating: rating
        rating = reviewArr[indexPath.row]


//        print(rating.rating,rating.comment)
//        print()

        cell.setItem(rating: rating)
        return cell
    }
}
