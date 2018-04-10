//
//  OnboardingViewController.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 24/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import UIKit
import CoreLocation

protocol OnboardingViewControllerDelegate: class {
    func didGiveLocationPermissions(_ onboardingViewController: OnboardingViewController)
}

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var enableLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    weak var delegate: OnboardingViewControllerDelegate?
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapOnEnableLocation(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension OnboardingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            delegate?.didGiveLocationPermissions(self)
        }
    }
}
