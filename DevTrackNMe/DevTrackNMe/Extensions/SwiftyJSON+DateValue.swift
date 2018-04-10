//
//  SwiftyJSON+DateValue.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 30/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-ddTHH:mm:ss"
        dateFormatter.calendar = Calendar.current
        return dateFormatter
    }()

    public var date: Date? {
        
        get {
            switch self.type {
            case .string:
                return JSON.dateFormatter.date(from: self.string!)
            default:
                return nil
            }
        }
    }
    
    public var dateValue: Date {
        
        get {
            switch self.type {
            case .string:
                return JSON.dateFormatter.date(from: self.string!) ?? Date()
            default:
                return Date()
            }
        }
    }
}
