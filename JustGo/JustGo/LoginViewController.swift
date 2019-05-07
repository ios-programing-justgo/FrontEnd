//
//  LoginViewController.swift
//  JustGo
//
//  Created by Hansa Chen on 5/7/19.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 222.0/255.0, green: 160.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func dissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
                self.handleError(error!)
                return
            } else {
                print("Login Successful!")
                self.performSegue(withIdentifier: "LoginToHome", sender: self)
            }
        }
    }
}
