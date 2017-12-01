//
//  HistoryTableViewController.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 30/11/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import UIKit
import RealmSwift

extension UITableViewCell: Reusable {}

protocol HistoryTableViewControllerDelegate: class {
    func dismiss(_ historyViewController: HistoryTableViewController)
}

class HistoryTableViewController: UITableViewController {

    var coordinateModel: Results<Coordinate>?
    var notificationToken: NotificationToken?
    
    var delegate: HistoryTableViewControllerDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self)
        
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
        var cell = tableView.dequeueReusableCell(for: indexPath) as UITableViewCell
        
        // force a change of style
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: UITableViewCell.identifier)
        }
        
        let coordinate = coordinateModel?[indexPath.row]
        cell.textLabel?.text = "\(String(describing: coordinate?.date))"
        cell.detailTextLabel?.text = "\(String(describing: coordinate?.latitude)) - \(String(describing: coordinate?.longitude))"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
