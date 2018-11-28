//
//  TapViewContriller.swift
//  OnTheMap
//
//  Created by بدور on 22/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import UIKit

class TabBarViewContriller: UITabBarController  {
        
    //MARK: Properties
    
    let udacity = Udacity.sharedInstance()
    let parse = Parse.sharedInstance()
    let datasource = StudentsDatasource.sharedDataSource()

    //MARK: LifeCycle Methods
    

    //MARK: Actions
    @IBAction func logoutClicked(_ sender: Any) {
      
        udacity.logout(){ (success, error) in
            if success == true {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async{
                    self.alertWithError(error: error!, title: Constants.Alert.LogoutAlertTitle)
                }  }  } }
    
    @IBAction func addLocation(_ sender: Any) {
        //1-get Student Object
        if let currentStudent = datasource.student {
       //2- check if student has location before
            parse.getParticularStudentLocation(uniqueKey: currentStudent.uniqueKey) { (location, error) in
               
                DispatchQueue.main.async {
                //3-A user has location before so we should get objectId so we can updated next
                    if let location = location {
                        self.overwriteAlert() { (alert)  in
                            self.datasource.objectId = location.objectID
                            self.presentPostingVC()
                        }
                    } else {
              //3-B user hasn't location before
                        self.presentPostingVC()
                    }   }  }   }   }
    
    @IBAction func refresh(_ sender: Any) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.notifications.studentLocationsPinnedDown), object: nil);
    }
  

    //MARK: Helper Methods
    private func presentPostingVC (){
        let viewControlller = self.storyboard?.instantiateViewController(withIdentifier: Constants.Identifiers.posting)
        present(viewControlller!, animated: true, completion: nil)
    }
    
    private func alertWithError(error: String, title: String) {
       
        let alertView = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: Constants.AlertActions.dismiss, style: .cancel, handler: nil))
        self.present(alertView, animated: true){
            self.view.alpha = 1.0
        }
    }
    
    private func overwriteAlert(completionClosure: @escaping (UIAlertAction) -> Void){
   let alertView = UIAlertController(title: Constants.Alert.overWriteAlert, message: Constants.Alert.overWriteMessage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: Constants.AlertActions.cancel, style: .cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: Constants.AlertActions.overWrite, style: .default, handler: completionClosure))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func studentLocationsPinnedDownError() {
        alertWithError(error: Constants.Errors.unableToUpdateLocations, title: "")
    }
}
