//
//  HistoryTableViewController.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 30/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMaps
import CoreLocation

class LocationCell: UITableViewCell, Reusable {
    
    var currentIndex = 0
    
    override func prepareForReuse() {
        textLabel?.text = ""
        detailTextLabel?.text = ""
    }
}

protocol HistoryTableViewControllerDelegate: class {
    func dismiss(_ historyViewController: HistoryTableViewController)
}

class HistoryTableViewController: UITableViewController {

    var coordinateModel: Results<Coordinate>?
    var notificationToken: NotificationToken?
    let geocoder = GMSGeocoder()
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatter.calendar = Calendar.current
        return dateFormatter
    }()
    
    var delegate: HistoryTableViewControllerDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Histórico"

        tableView.register(LocationCell.self)
        
        notificationToken = coordinateModel?.addNotificationBlock({ [weak self] (changes) in
            switch changes {
            case .initial(_):
                self?.tableView.reloadData()
                break
            case .update(_, _, let insertions, _):
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self?.tableView.endUpdates()
                break
            case .error(let error):
                print(error)
                break
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return coordinateModel?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(for: indexPath) as LocationCell
        
        // force a change of style
        if cell.detailTextLabel == nil {
            cell = LocationCell(style: .subtitle, reuseIdentifier: LocationCell.identifier)
        }
        
        let coordinate = coordinateModel?[indexPath.row]
        let location = CLLocationCoordinate2D(latitude: coordinate?.latitude ?? 0.0,
                                              longitude: coordinate?.longitude ?? 0.0)

        cell.currentIndex = indexPath.row
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        geocoder.reverseGeocodeCoordinate(location) { (response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard error == nil, cell.currentIndex == indexPath.row else {
                cell.detailTextLabel?.text = "LAT: \(coordinate?.latitude ?? 0) - LONG: \(coordinate?.longitude ?? 0)"
                cell.textLabel?.text = HistoryTableViewController.dateFormatter.string(from: coordinate?.date ?? Date())
                
                return
            }

            if let firstAddress = response?.results()?.first {
                cell.textLabel?.text = firstAddress.addressLine1()
                var subtitle = ""
                if let addressLine2 = firstAddress.addressLine2() {
                    subtitle = addressLine2 + " - "
                }

                subtitle += HistoryTableViewController.dateFormatter.string(from: coordinate?.date ?? Date())
                cell.detailTextLabel?.text = subtitle
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
