//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by بدور on 20/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate {
    
    //MARK: UI Configuration Enum
    enum UIState { case  Normal, Login }
    
    //MARK: Outlets & Properties
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let udacity = Udacity.sharedInstance()
    let datasource = StudentsDatasource.sharedDataSource()
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set UI State
        setUIForState(.Normal)
        
        //Confirm TextFields Delegate's
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //MARK: Actions
    
    @IBAction func loginClicked(_ sender: Any) {
       
     
        if emailTextField.text!.isEmpty {
            self.alertWithError(error: Constants.Errors.usernameEmpty)
        } else if (passwordTextField.text?.isEmpty)! {
            self.alertWithError(error: Constants.Errors.passwordEmpty)
        }
        else {
            // Set UI State
            setUIForState(.Login)
            //1 - send email and password to check if user exist
            udacity.loginWithCredentials(username: emailTextField.text!, password: passwordTextField.text!) { (userKey, error) in
                DispatchQueue.main.async {
                    //2- send user key to get user information
                    if let userKey = userKey {
                        self.udacity.fetchStudentData(fromKey: userKey) { (student, error) in
                            DispatchQueue.main.async {
                                if let student = student {
                                    self.datasource.student = student
                                    self.performSegue(withIdentifier: Constants.Identifiers.loginSegue, sender: self)
                                } else {
                                    self.alertWithError(error: error!)
                                }  } }   }
                    else {
                        // wrong in email or password
                        self.alertWithError(error: error!)
                    } }  }  } }
    
  
    @IBAction func signUpClicked(_ sender: Any) {
        
        if let signUpURL = URL(string: Udacity.signUpURL), UIApplication.shared.canOpenURL(signUpURL) {
            UIApplication.shared.open(signUpURL)
        }
    }
    
    //MARK: Helper Methods
    
    func setUIForState(_ state: UIState) {
        switch state {
      
        case .Normal:
            setEnabled(enabled: true)
            emailTextField.text = ""
            passwordTextField.isSecureTextEntry = true
            passwordTextField.text = ""
            activityIndicator.stopAnimating()
           contentStackView.alpha = 1.0
            
        case .Login:
            setEnabled(enabled: false)
            activityIndicator.startAnimating()
            contentStackView.alpha = 0.5
            errorLabel.text = ""
            
        }
    }
    
    private func setEnabled(enabled: Bool){
        activityIndicator.isHidden = enabled
        loginButton.isEnabled = enabled
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
    }
    
    private func alertWithError(error: String) {
        
        let alertView = UIAlertController(title: Constants.Alert.LoginAlertTitle, message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constants.AlertActions.dismiss, style: .cancel) {
            UIAlertAction in
            self.setUIForState(.Normal)
        }
        alertView.addAction(cancelAction)
        self.present(alertView, animated: true){
            self.contentStackView.alpha = 1.0
        }    
    }
    // text field delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
