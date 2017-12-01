//
//  Reusable.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 01/12/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import UIKit

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable where Self: UIView {
    
    static var identifier: String {
        return String(describing: self)
    }
}
