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
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 222.0/255.0, green: 160.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        passwordTextField.isSecureTextEntry = true
        
        userImageView.image = UIImage(named:"user_male")
        passwordImageView.image = UIImage(named:"key")
        
        self.addLineToView(view: emailTextField, position:.LINE_POSITION_BOTTOM, color: UIColor.darkGray, width: 0.5)
        self.addLineToView(view: passwordTextField, position:.LINE_POSITION_BOTTOM, color: UIColor.darkGray, width: 0.5)
        
        emailTextField.backgroundColor = UIColor(red: 222.0/255.0, green: 160.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        passwordTextField.backgroundColor = UIColor(red: 222.0/255.0, green: 160.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        
       //hide keyboard
       self.hideKeyboardWhenTypedAround()
        
        
    }
    
    
    enum LINE_POSITION {
        case LINE_POSITION_TOP
        case LINE_POSITION_BOTTOM
    }

    
    func addLineToView(view : UIView, position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        view.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        default:
            break
        }
    }
    @IBAction func dissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        if emailTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Email can not be empty!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else if passwordTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Password can not be empty!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
                self.handleError(error!)
                return
            } else {
                print("Login Successful!")
                self.performSegue(withIdentifier: "LoginToHome", sender: nil)
            }
        }
    }
}


extension UIViewController {
    func hideKeyboardWhenTypedAround(){
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
                tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
