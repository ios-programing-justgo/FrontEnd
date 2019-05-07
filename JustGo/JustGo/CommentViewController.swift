//
//  CommentViewController.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/7.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UITableView!
    @IBOutlet weak var commentLabel: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var submitReviewButton: UIButton!
    
    var commentArr = [rating]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func submitPressed(_ sender: Any) {
    }
}


extension CommentViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return commentArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        let item: Item

        item = itemArr[indexPath.row]
        
        cell.setItem(item: item)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArr[indexPath.row]
        performSegue(withIdentifier: "ListToDetail", sender: item)
    }
    
}
