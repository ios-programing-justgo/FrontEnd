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
    @IBOutlet weak var nameTextField: UITextField!
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
    
    @IBAction func registerPresseded(_ sender: Any) {
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        if emailTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Email can not be empty", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if passwordTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Password is empty", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if retypePasswordTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Retype password is empty", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        else if retypePasswordTextField.text! != passwordTextField.text! {
            let alert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
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
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let changeRequest = user.createProfileChangeRequest()
                        changeRequest.displayName = self.nameTextField.text
                        changeRequest.commitChanges(completion: nil)
                        }
                    print("Registration Successful!")
                    let alert = UIAlertController(title: "Agree", message: "You have successfully registered for an account", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
//                        self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "RegisterToHome", sender: nil)
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
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


