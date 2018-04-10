//
//  FirstRunKeeper.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 24/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import Foundation

protocol FirstRunKeeper {
    var hasFirstRun: Bool { get }
    func setFirstRun(_ value: Bool)
}
