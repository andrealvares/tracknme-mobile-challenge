//
//  MovementViewController+LocationManager.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 17/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit
import GoogleMaps

extension MovementViewcontroller : CLLocationManagerDelegate{
    // MARK: - Location stuff
    
    func getLocation(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("Log: Locations size: %i", locations.count)
        if(locations.count > 0){
            let location = locations[0]
            self.currentPosition = location.coordinate
            self.centerUserTo()
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ locationManager: CLLocationManager, didFailWithError error: Error){
        NSLog("Log: didFailWithError : %@", error.localizedDescription)
    }
    
    func locationManager(_ locationManager: CLLocationManager, didFinishDeferredUpdatesWithError: Error?){
        NSLog("Log: didFinishDeferredUpdatesWithError")
    }
    
    func locationManagerDidPauseLocationUpdates(_ locationManager: CLLocationManager){
        NSLog("Log: locationManagerDidPauseLocationUpdates")
    }
    
    func locationManagerDidResumeLocationUpdates(_ locationManager: CLLocationManager){
        NSLog("Log: locationManagerDidResumeLocationUpdates")
    }
    
    func locationManager(_ locationManager: CLLocationManager, didUpdateHeading: CLHeading){
        NSLog("Log: didUpdateHeading")
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        NSLog("Log: locationManagerShouldDisplayHeadingCalibration")
        return false
    }
    
    func locationManager(_ locationManager: CLLocationManager, didEnterRegion: CLRegion){
        NSLog("Log: didEnterRegion")
    }
    
    func locationManager(_ locationManager: CLLocationManager, didExitRegion: CLRegion){
        NSLog("Log: didExitRegion")
    }
    
    func locationManager(_ locationManager: CLLocationManager, didDetermineState: CLRegionState, for: CLRegion){
        NSLog("Log: didDetermineState")
    }
    
    func locationManager(_ locationManager: CLLocationManager, monitoringDidFailFor: CLRegion?, withError: Error){
        NSLog("Log: monitoringDidFailFor")
    }
    
    func locationManager(_ locationManager: CLLocationManager, didStartMonitoringFor: CLRegion){
        NSLog("Log: didStartMonitoringFor")
    }
    
    func locationManager(_ locationManager: CLLocationManager, didRangeBeacons: [CLBeacon], in: CLBeaconRegion){
        NSLog("Log: didRangeBeacons")
    }
    
    func locationManager(_ locationManager: CLLocationManager, rangingBeaconsDidFailFor: CLBeaconRegion, withError: Error){
        NSLog("Log: rangingBeaconsDidFailFor")
    }
    
    func locationManager(_ locationManager: CLLocationManager, didVisit: CLVisit){
        NSLog("Log: didVisit")
    }
    
    func locationManager(_ locationManager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        NSLog("Log: didChangeAuthorization")
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //handle denied
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
}
