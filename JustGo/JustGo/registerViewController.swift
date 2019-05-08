//
//  registerViewController.swift
//  JustGo
//
//  Created by Hansa Chen on 5/7/19.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit
import Firebase

class registerViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var registerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 222.0/255.0, green: 160.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        passwordTextField.isSecureTextEntry = true
        retypePasswordTextField.isSecureTextEntry = true
        
        registerImageView.image = UIImage(named:"user_group_man_woman")
        
        self.hideKeyboardWhenTypedAround()

    }
    @IBAction func dissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerPresseded(_ sender: UIButton) {
        
        if retypePasswordTextField == nil {
            let alert = UIAlertController(title: "Error", message: "retype password is empty", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        else if retypePasswordTextField.text! != passwordTextField.text! {
            let alert = UIAlertController(title: "Error", message: "passwords do not match", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    print(error!)
                    self.handleError(error!)
                    return
                    
                } else {
                    print("Registration Successful!")
                    let defaultAction = UIAlertAction(title: "Agree", style: .default) { (action) in
                        self.performSegue(withIdentifier: "RegisterToHome", sender: self)
                    }
                    let alert = UIAlertController(title: "Success", message: "You have successfully registered for an account", preferredStyle: .alert)
                    alert.addAction(defaultAction)
                    
                    self.present(alert, animated: true) {
                        // The alert was presented
                    }
                }
            }
        }
    }
    
}
extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again"
        default:
            return "Unknown error occurred"
        }
    }
}


extension UIViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}


