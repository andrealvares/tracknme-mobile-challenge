//
//  AddNewLocationViewController.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 01/12/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import UIKit
import Moya

protocol AddNewLocationViewControllerDelegate: class {
    func cancel(_ addNewLocationViewController: AddNewLocationViewController)
    func addLocation(_ addNewLocationViewController: AddNewLocationViewController, newCoordinate: Coordinate)
}

class AddNewLocationViewController: UIViewController {

    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    
    var currentDate = Date()
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    
    let provider = MoyaProvider<LocationAPI>()
    var delegate: AddNewLocationViewControllerDelegate?
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/YYYY"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDateLabel.text = dateFormatter.string(from: currentDate)
        latitudeField.text = currentLatitude.description
        longitudeField.text = currentLongitude.description
    }
    
    @IBAction func didTapOnCancelButton(_ sender: Any) {
        delegate?.cancel(self)
    }
    
    @IBAction func didTapOnAddButton(_ sender: Any) {
        guard
            let latitude = Double(latitudeField.text ?? "0"),
            let longitude = Double(longitudeField.text ?? "0") else {
                return
        }
        
        let newCoordinate = Coordinate()
        newCoordinate.date = currentDate
        newCoordinate.latitude = latitude
        newCoordinate.longitude = longitude
        
        provider.request(.create(coordinate: newCoordinate)) { (result) in}
        delegate?.addLocation(self, newCoordinate: newCoordinate)
    }
}
