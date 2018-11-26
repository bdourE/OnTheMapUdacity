//
//  MapViewController.swift
//  OnTheMap
//
//  Created by بدور on 20/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Properties
    
    private let parse = Parse.sharedInstance()
    var studentLocations = [StudentLocationModel]()
    
    //MARK: LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observe()
        GetStudentsLocations()
    
    }
   
    //MARK: Helper Methods
    func GetStudentsLocations() {
        parse.getMultipleStudentLocations(){ (studentLocationDics, error) in
            // Check for Error
            if let _ = error {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.notifications.studentLocationsPinnedDownError), object: nil)
            } else {
                guard let studentLocationDics = studentLocationDics else {
                    return
                }
                self.studentLocations = studentLocationDics
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.notifications.studentLocationsPinnedDown), object: nil)
            }
        }
    }
    // function to reset location on the map when apdate
    @objc func studentLocationsUpdated() {
        if studentLocations.isEmpty {
            alertWithError(error: Constants.Errors.fetchingFailed)
            return
        }
        var annotations = [MKPointAnnotation]()
        for studentLocation in studentLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = studentLocation.location.coordinate
            annotation.title = studentLocation.student.fullName
            annotation.subtitle = studentLocation.student.mediaURL
            annotations.append(annotation)
        }
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
            self.view.alpha = 1.0
        }
    }
    
    func observe() {
        // Observe Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsUpdated), name: NSNotification.Name(rawValue: Constants.notifications.studentLocationsPinnedDown), object: nil)
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

// MARK: - MapViewController: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = Constants.Identifiers.dropPinReuse
        
        var dropPinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if dropPinView == nil {
            dropPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            dropPinView!.canShowCallout = true
            dropPinView!.pinTintColor = UIColor.red
            dropPinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            dropPinView!.annotation = annotation
        }
        
        return dropPinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaURL = NSURL(string: ((view.annotation?.subtitle)!)!) {
                if UIApplication.shared.canOpenURL(mediaURL as URL) {
                    UIApplication.shared.open(mediaURL as URL)
                } else {
                    alertWithError(error: Constants.Errors.cannotOpenURL)
                }
            }
        }
    }}
