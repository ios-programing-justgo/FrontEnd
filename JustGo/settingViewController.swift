//
//  settingViewController.swift
//  JustGo
//
//  Created by Hansa Chen on 5/7/19.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit
import Firebase

class settingViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        userName.text = user?.displayName

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutPressed(_ sender: Any) {
        do {
           try Auth.auth().signOut()
        }
        catch {
          print("There is a problem signing out")
        }
       
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            
        else {
            print("you are signed out")
            return
        }
    }
    

}
