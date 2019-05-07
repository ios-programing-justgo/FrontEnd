//
//  SeachPageViewController.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/6.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit

class SeachPageViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    var toPass:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 222.0/255.0, green: 160.0/255.0, blue: 65.0/255.0, alpha: 1.0)
    }
    
    //passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToList"{
            let tabBarVC = segue.destination as! UITabBarController
            let navVC = tabBarVC.viewControllers![0] as! UINavigationController
            let destination = navVC.viewControllers.first as! ItemListScreen
            destination.search_text = searchTextField.text!
        }
    }
    
}
