//
//  Position.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 17/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Position: Object {
    @objc dynamic var date : Date = Date()
    @objc dynamic var lat : Double = 0
    @objc dynamic var lng : Double = 0
    @objc dynamic var geocodedAddress : String = ""
    @objc dynamic var postedToBackend : Bool = false
    
    var tableViewCell: PositionTableViewCell?
    
    required init() {
        super.init()
        
        date = Date()
        lat = 0
        lng = 0
        geocodedAddress = ""
        postedToBackend = false
        tableViewCell = nil
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)

    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)

    }
    
    func toString() -> String{
        return String(format: "lat: %f, lng: %f, date: %@, address: %@", self.lat, self.lng, self.date.description, self.geocodedAddress)
    }
    
    class func parseObjFromDictionary(dictionary: Dictionary<String, AnyObject>) -> Position{
        let position = Position()
        position.lat = dictionary["latitude"]?.doubleValue ?? 0
        position.lng = dictionary["longitude"]?.doubleValue ?? 0

        let formatter = DateFormatter()
        position.date = formatter.date(fromApiString: dictionary["dateTime"] as? String ?? "") ?? Date()
        
        return position
    }
    
    func getDictionary() -> [String : Any]{
        var meAsDict: [String : Any] = [:]
        let formatter = DateFormatter()
        
        meAsDict["dateTime"] = formatter.date(toApiString: self.date)
        meAsDict["latitude"] = lat
        meAsDict["longitude"] = lng
        
        return meAsDict
    }
    
    override static func ignoredProperties() -> [String] {
        return ["tableViewCell"]
    }
}

extension DateFormatter {
    func date(fromApiString dateString: String) -> Date? {
        // API dates look like: "2014-12-10T16:44:31.486000Z"
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "en_US_POSIX")
        return self.date(from: dateString)
    }
    
    func date(toApiString date: Date) -> String {
        // API dates look like: "2014-12-10T16:44:31.486000Z"
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "en_US_POSIX")
        return self.string(from: date)
    }
}
