//
//  Coordinate.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 26/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Coordinate {
    
    let date: Date
    let latitude: Double
    let longitude: Double
    
    init(json: JSON) {
        date = json["dateTime"].dateValue
        latitude = json["latitude"].doubleValue
        longitude = json["longitude"].doubleValue
    }
}

struct RunService {
    
    static func getFirstCoordinates() -> [Coordinate] {
        
        let bundleCoordinates = Bundle.main.loadJSONArray(named: "posicoes")
        return bundleCoordinates.arrayValue.map({ (jsonCoordinate) -> Coordinate in
            return Coordinate(json: jsonCoordinate)
        })
    }
}
