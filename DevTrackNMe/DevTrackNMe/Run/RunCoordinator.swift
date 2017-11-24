//
//  RunCoordinator.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 24/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import UIKit

class RunCoordinator: CoordinatorType {
    
    let navigationController: UINavigationController
    let firstRunKeeper: FirstRunKeeper
    let needFirstRun: Bool
    
    init(navigationController: UINavigationController, firstRunKeeper: FirstRunKeeper, needFirstRun: Bool) {
        self.navigationController = navigationController
        self.firstRunKeeper = firstRunKeeper
        self.needFirstRun = needFirstRun
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        
        navigationController.navigationBar.isHidden = false
        navigationController.setViewControllers([viewController], animated: true)
    }
}
