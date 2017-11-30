//
//  Bundle+LoadResource.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 26/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Bundle {
    
    func loadJSONArray(named: String) -> JSON {
        do {
            if let file = url(forResource: named, withExtension: "json") {
                let data = try Data(contentsOf: file)
                return JSON(data)
            }
            
            return JSON.null
        } catch {
            print(error.localizedDescription)
            return JSON.null
        }
    }
}
