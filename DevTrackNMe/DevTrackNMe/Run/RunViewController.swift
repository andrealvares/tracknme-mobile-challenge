//
//  ViewController.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 24/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift

protocol RunViewControllerDelegate: class {
    func didGetFirstLocation(_ runViewController: RunViewController, location: CLLocation)
    func didAddNewDestination(_ runViewController: RunViewController)
    func didAddNewDestination(_ runViewController: RunViewController, with location: CLLocationCoordinate2D)
    func didTapToHistory(_ runViewController: RunViewController)
}

class RunViewController: UIViewController {

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    let geocoder = GMSGeocoder()
    var mapView: GMSMapView!
    var path: GMSMutablePath!
    var zoomLevel: Float = 6
    
    var coordinateModel: Results<Coordinate>?
    var notificationToken: NotificationToken?
    
    var delegate: RunViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
        setupRealmObserver()
        setupNavigationBarButtons()
    }
    
    func setupRealmObserver(){
        notificationToken = coordinateModel?.addNotificationBlock { (changes) in
            switch changes {
            case .initial(let coordinates):
            
                coordinates.forEach({ (coordinate) in
                    self.path.addLatitude(coordinate.latitude, longitude: coordinate.longitude)
                    self.createMapMarker(for: coordinate)
                })
                
                let polyline = GMSPolyline(path: self.path)
                polyline.map = self.mapView
                
                break
                
            case .update(let coordinates, _, let insertions, _):
                insertions.forEach({ (index) in
                    let coordinate = coordinates[index]
                    self.path.addLatitude(coordinate.latitude, longitude: coordinate.longitude)
                    self.createMapMarker(for: coordinate)
                })
                let polyline = GMSPolyline(path: self.path)
                polyline.map = self.mapView
                break
                
            default: return
            }
        }
    }
    
    func setupMapView(){
        mapView = GMSMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isHidden = true
        view.addSubview(mapView)
        
        path = GMSMutablePath()
    }
    
    func setupLocationManager(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        currentLocation = locationManager.location
    }
    
    
    func createMapMarker(for coordinate: Coordinate) {
        // Creates a marker in the center of the map.
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let marker = GMSMarker()
        marker.position = location.coordinate
        marker.map = mapView
        
        geocoder.reverseGeocodeCoordinate(location.coordinate) { (response, error) in
            guard error == nil else {
                return
            }
            
            if let firstAddress = response?.results()?.first {
                marker.title = firstAddress.addressLine1()
                marker.snippet = firstAddress.addressLine2()
            }
        }
    }
    
    func setupNavigationBarButtons(){
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapToAdd(_:)))
        let leftBarButton = UIBarButtonItem(title: "Histórico", style: .plain, target: self, action: #selector(didTapToHistory(_:)))
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func didTapToAdd(_ sender: Any){
        delegate?.didAddNewDestination(self)
    }
    
    @objc func didTapToHistory(_ sender: Any){
        delegate?.didTapToHistory(self)
    }
}

// MARK: LocationManager Delegate
extension RunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }

        manager.stopUpdatingLocation()
        delegate?.didGetFirstLocation(self, location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension RunViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        delegate?.didAddNewDestination(self, with: coordinate)
    }
}

