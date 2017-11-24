//
//  Bundle+TargetProperties.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 24/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import Foundation

extension Bundle {
    
    var googleMapsAPIKey: String {
        return infoDictionary!["GoogleMapsAPIKey"] as! String
    }
}
