//
//  StudentsDatasource.swift
//  OnTheMap
//
//  Created by بدور on 28/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import Foundation
class StudentsDatasource{
    //MARK: Properties
    private let parse = Parse.sharedInstance()
    var studentLocations = [StudentLocationModel]()
    var student: StudentModel? = nil
     var objectId : String?
    //MARK: Singleton Instance
    private static let sharedInstance = StudentsDatasource()
    
    class func sharedDataSource() -> StudentsDatasource  {
        return sharedInstance
    }
    
    //MARK: Pin Down Students Locations
    
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.notifications.studentLocationsPinnedDown), object: nil);
            }
        }
    }
}
