//
//  Student.swift
//  OnTheMap
//
//  Created by بدور on 20/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import Foundation
struct StudentModel {
    
    let uniqueKey: String
    let firstName: String
    let lastName: String
    var mediaURL: String
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(uniqueKey: String, firstName: String, lastName: String , mediaURL: String) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mediaURL = mediaURL
    }
    
}
