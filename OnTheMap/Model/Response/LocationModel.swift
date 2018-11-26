//
//  LocationModel.swift
//  OnTheMap
//
//  Created by بدور on 20/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import Foundation
import MapKit

struct LocationModel {
    let latitude: Double
    let longitude: Double
    let mapString: String
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}
