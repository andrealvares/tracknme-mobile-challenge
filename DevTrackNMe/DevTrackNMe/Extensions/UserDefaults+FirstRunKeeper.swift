//
//  UserDefaults+FirstRunKeeper.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 24/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import Foundation

extension UserDefaults: FirstRunKeeper {
    
    var hasFirstRun: Bool {
        return bool(forKey: "hasFirstRun")
    }
    
    func setFirstRun(_ value: Bool) {
        set(value, forKey: "hasFirstRun")
    }
}
