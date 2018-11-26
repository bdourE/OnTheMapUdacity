//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by بدور on 23/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import Foundation
import  UIKit
class InformationPostingViewController : UIViewController , UITextFieldDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelClicked(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findClicked(_ sender: AnyObject) {
        // Check if location textfield is empty or not.
        if (locationTextField.text?.isEmpty)! {
            alertWithError(error: Constants.Errors.emptyLocation)
            return
        }
        // check for empty media url
        if mediaURLTextField.text!.isEmpty {
            alertWithError(error: Constants.Errors.emptyurl)
            return
        }
        else {
        performSegue(withIdentifier: Constants.Identifiers.openMap , sender: self)
        }
    }

    func alertWithError(error: String) {
        
        self.view.alpha = 1.0
        let alertView = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:Constants.AlertActions.dismiss, style: .cancel, handler: nil))
        self.present(alertView, animated: true){
            self.view.alpha = 1.0
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.Identifiers.openMap) {
            let vc = segue.destination as! FindLocationViewController
            vc.loc = locationTextField.text
            vc.mediaURL = mediaURLTextField.text
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }}
