//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by بدور on 23/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import UIKit
import MapKit
class  FindLocationViewController: UIViewController {
   
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView?
    
    //MARK: Properties
    private let udacity = Udacity.sharedInstance()
    private let parse = Parse.sharedInstance()
    
    
    private var mark: CLPlacemark? = nil
    var loc : String?
    var mediaURL : String?
    var objectId : String?
    
    override func viewDidLoad() {
        
        objectId = self.parse.objectId
        
        //Add the placemark on the location
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(loc!) { (placemarkArr, error) in
            
            //Check for errors
            if let _ = error {
                self.alertWithError(error: Constants.Errors.couldNotGeocode)
            } else if (placemarkArr?.isEmpty)! {
                self.alertWithError(error: Constants.Errors.noLocationFound)
            } else {
                self.mark = placemarkArr?.first
                self.mapView?.showAnnotations([MKPlacemark(placemark: self.mark!)], animated: true)
            }
        }
    }
 
    @IBAction func submitClicked(_ sender: AnyObject) {
     //1- create location Object
        let location = LocationModel(latitude: (mark?.location?.coordinate.latitude)!, longitude: (mark?.location?.coordinate.longitude)!, mapString: mediaURL!)
        
      //2-A if user has location before update with new one
        if let objectId = objectId {
            parse.updateStudentLocationWith(mediaURL: mediaURL!, studentData: StudentLocationModel(objectID: objectId, student: udacity.student!, location: location)) { (success, error) in
                if let e = error {
                    self.alertWithError(error: e)
                } else {
                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.notifications.studentLocationsPinnedDown), object: nil)
                    self.udacity.student?.mediaURL = self.mediaURL!
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        //2-A if user hasn't location before post new one
        else {
            parse.postStudentsLocation(studentData: StudentLocationModel(student: udacity.student!, location: location), mediaURL: mediaURL!) { (success, error) in
                if let _ = error {
                    self.alertWithError(error: Constants.Errors.postingFailed)
                } else {
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.notifications.studentLocationsPinnedDown), object: nil);
                    self.udacity.student?.mediaURL = self.mediaURL!
                    self.dismiss(animated: true, completion: nil)
                }
            }
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
}
