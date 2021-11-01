//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/09/27.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        OTMClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
        //setlogingin and perform segue
    }
    
    @IBAction func signUpButtonTapped(_ sender:UIButton){
        openLink(url: "https://auth.udacity.com/sign-up")
    }
    
    
    
    
    func handleLoginResponse(success: Bool, error: Error?){
        if success {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
            OTMClient.getPublicUserData(){response, error in
                if response == true {
                    print("Successfully recieved userdata \(OTMClient.Auth.firstName)")
                    self.setLoggingIn(false)
                    
                } else {
                    self.showAlert(title: "Login Failed", message: error?.localizedDescription ?? "")
                    //self.showLoginFailure(message: error?.localizedDescription ?? "")
                    self.setLoggingIn(false)
                }
            }
            
        } else {
            self.showAlert(title: "Login Failed", message: error?.localizedDescription ?? "")
            setLoggingIn(false)
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool){
        loggingIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
}

