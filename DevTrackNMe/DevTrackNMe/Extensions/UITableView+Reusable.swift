//
//  UITableView+Reusable.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 30/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ :T.Type) where T: Reusable {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not possible to dequeue \(T.identifier)")
        }
        
        return cell
    }
}
