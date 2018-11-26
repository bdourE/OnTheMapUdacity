//
//  TableViewController.swift
//  OnTheMap
//
//  Created by بدور on 26/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import Foundation

import UIKit

class TableViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
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
    // fixed hieght for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    @objc func studentLocationsUpdated() {
        DispatchQueue.main.async {
            self.tableView.alpha = 1.0
            self.tableView.reloadData()
        }}
    
    func alertWithError(error: String) {
        let alertView = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: Constants.AlertActions.dismiss, style: .cancel, handler: nil))
        self.present(alertView, animated: true){
            self.view.alpha = 1.0
        }
    }
    func observe() {
        // Observe Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsUpdated), name: NSNotification.Name(rawValue: Constants.notifications.studentLocationsPinnedDown), object: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.studentLocationCell) as! StudentLocationCell
            let studentLocation = studentLocations[indexPath.row]
            cell.configureStudentLocationCell(studentLocation: studentLocation)
            return cell
        }
    
        //MARK: Table Delegates
        
         func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let studentURL = studentLocations[indexPath.row].student.mediaURL
            
            // Check if it exists & proceed accordingly
            if let studentMediaURL = URL(string: studentURL), UIApplication.shared.canOpenURL(studentMediaURL) {
                // Open URL
                UIApplication.shared.open(studentMediaURL)
            } else {
                // Return with Error
                alertWithError(error: Constants.Errors.cannotOpenURL)
            }
        
    }}
