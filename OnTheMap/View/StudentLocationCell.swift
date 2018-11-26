//
//  StudentLocationCell.swift
//  OnTheMap
//
//  Created by بدور on 26/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import Foundation
import UIKit

class StudentLocationCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var mediaURL: UILabel!
    
    func configureStudentLocationCell(studentLocation: StudentLocationModel){
    
        fullName.text = studentLocation.student.fullName
        mediaURL.text = studentLocation.student.mediaURL
    }
    
}
