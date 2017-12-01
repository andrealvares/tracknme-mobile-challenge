//
//  AddNewLocationViewController.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 01/12/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import UIKit

protocol AddNewLocationViewControllerDelegate: class {
    func cancel(_ addNewLocationViewController: AddNewLocationViewController)
    func addLocation(_ addNewLocationViewController: AddNewLocationViewController, date: Date, latitude: Double, longitude: Double)
}

class AddNewLocationViewController: UIViewController {

    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    
    var currentDate = Date()
    var delegate: AddNewLocationViewControllerDelegate?
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/YYYY"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        currentDateLabel.text = dateFormatter.
    }
    
    @IBAction func didTapOnCancelButton(_ sender: Any) {
        delegate?.cancel(self)
    }
    
    @IBAction func didTapOnAddButton(_ sender: Any) {
        
    }
}
