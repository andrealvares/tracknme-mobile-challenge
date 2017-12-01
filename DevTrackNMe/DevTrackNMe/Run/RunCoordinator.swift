//
//  RunCoordinator.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 24/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class RunCoordinator: CoordinatorType {
    
    let navigationController: UINavigationController
    let firstRunKeeper: FirstRunKeeper
    let needFirstRun: Bool
    let realm = try! Realm(configuration: Realm.Configuration.defaultConfiguration)
    
    init(navigationController: UINavigationController, firstRunKeeper: FirstRunKeeper, needFirstRun: Bool) {
        self.navigationController = navigationController
        self.firstRunKeeper = firstRunKeeper
        self.needFirstRun = needFirstRun
    }
    
    func start() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let runViewController = storyboard.instantiateViewController(withIdentifier: "RunViewController") as! RunViewController
        runViewController.delegate = self
        
        // Inject realm dependecy
        runViewController.coordinateModel = realm.objects(Coordinate.self)
        
        navigationController.navigationBar.isHidden = false
        navigationController.setViewControllers([runViewController], animated: true)
    }
}

extension RunCoordinator: RunViewControllerDelegate {
    func didAddNewDestination(_ runViewController: RunViewController) {
        
    }
    
    func didTapToHistory(_ runViewController: RunViewController) {
        let historyViewController = HistoryTableViewController()
        historyViewController.coordinateModel = realm.objects(Coordinate.self)
        historyViewController.delegate = self
        navigationController.pushViewController(historyViewController, animated: true)
    }
    
    
    func didGetFirstLocation(_ runViewController: RunViewController, location: CLLocation) {
        if needFirstRun {
            let firstCoordinate = Coordinate()
            firstCoordinate.date = Date()
            firstCoordinate.latitude = location.coordinate.latitude
            firstCoordinate.longitude = location.coordinate.longitude
            
            var coordinates = RunService.getFirstCoordinates()
            coordinates.insert(firstCoordinate, at: 0)
            
            try! realm.write {
                realm.add(coordinates)
            }
            
            firstRunKeeper.setFirstRun(true)
        }
    }
}

extension RunCoordinator: HistoryTableViewControllerDelegate {
    
    func dismiss(_ historyViewController: HistoryTableViewController) {
        historyViewController.navigationController?.popViewController(animated: true)
    }
}




