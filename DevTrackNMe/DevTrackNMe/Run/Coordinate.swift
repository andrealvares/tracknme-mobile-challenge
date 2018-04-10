//
//  Coordinate.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 26/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

struct RunService {
    
    static func getFirstCoordinates() -> [Coordinate] {
        
        let bundleCoordinates = Bundle.main.loadJSONArray(named: "posicoes")
        return bundleCoordinates.arrayValue.map({ (jsonCoordinate) -> Coordinate in
            
            let coordinate = Coordinate()
            coordinate.date = jsonCoordinate["dateTime"].dateValue
            coordinate.latitude = jsonCoordinate["latitude"].doubleValue
            coordinate.longitude = jsonCoordinate["longitude"].doubleValue
            
            return coordinate
        })
    }
}

class Coordinate: Object {
    
    @objc dynamic var date = Date()
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    func toJSON() -> JSON {
        var json = JSON()
        json["dateTime"].stringValue = JSON.dateFormatter.string(from: date)
        json["latitude"].doubleValue = latitude
        json["longitude"].doubleValue = longitude
        return json
    }
}
