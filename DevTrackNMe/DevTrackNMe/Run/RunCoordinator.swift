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
    func didAddNewDestination(_ runViewController: RunViewController, with location: CLLocationCoordinate2D) {
        let storyboard = UIStoryboard(name: "AddNewLocation", bundle: Bundle.main)
        let addNewLocationViewController = storyboard.instantiateViewController(withIdentifier: "AddNewLocationViewController") as! AddNewLocationViewController
        addNewLocationViewController.delegate = self
        addNewLocationViewController.modalPresentationStyle = .overCurrentContext
        addNewLocationViewController.modalTransitionStyle = .crossDissolve
        addNewLocationViewController.currentLatitude = location.latitude
        addNewLocationViewController.currentLongitude = location.longitude
        
        navigationController.topViewController?.present(addNewLocationViewController, animated: true, completion: nil)
    }
    
    func didAddNewDestination(_ runViewController: RunViewController) {
        let storyboard = UIStoryboard(name: "AddNewLocation", bundle: Bundle.main)
        let addNewLocationViewController = storyboard.instantiateViewController(withIdentifier: "AddNewLocationViewController") as! AddNewLocationViewController
        addNewLocationViewController.delegate = self
        addNewLocationViewController.modalPresentationStyle = .overCurrentContext
        addNewLocationViewController.modalTransitionStyle = .crossDissolve
        
        navigationController.topViewController?.present(addNewLocationViewController, animated: true, completion: nil)
    }
    
    func didTapToHistory(_ runViewController: RunViewController) {
        let historyViewController = HistoryTableViewController()
        historyViewController.coordinateModel = realm.objects(Coordinate.self).sorted(byKeyPath: "date", ascending: false)
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

extension RunCoordinator: AddNewLocationViewControllerDelegate {
    
    func cancel(_ addNewLocationViewController: AddNewLocationViewController) {
        addNewLocationViewController.dismiss(animated: true, completion: nil)
    }
    
    func addLocation(_ addNewLocationViewController: AddNewLocationViewController, newCoordinate: Coordinate) {

        try! realm.write {
            realm.add(newCoordinate)
        }
        
        cancel(addNewLocationViewController)
    }
}




