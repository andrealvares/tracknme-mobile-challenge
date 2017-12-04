//
//  HistoryViewController.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 16/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController, NotificationHandlerDelegate {
    @IBOutlet weak var historyTableView: UITableView!
    
    var historyPositions: [Position] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTableView.register(PositionTableViewCell.self, forCellReuseIdentifier: PositionTableViewCell.cellIdentifier)
        historyTableView.register(UINib(nibName: PositionTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: PositionTableViewCell.cellIdentifier)
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        NotificationServer.getInstance().subscribe(handler: self, forEvent: NotificationType.NewPosition)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchAndAddPositions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UI Methods
    func updatePositionInTable(position: Position){
        if let tableCell = position.tableViewCell{
            //Safe?
            if (tableCell.position == position){
                tableCell.updateAddress()
            }
        }
    }

    //MARK: - Notification Handler method
    func handleNotification(notification : NotificationType){
        NSLog("Notified about: %@", notification.rawValue)
        self.searchAndAddPositions()
    }
    
    func searchAndAddPositions(){
        var pendingPositionsResult: Results<Position>
        
        if(historyPositions.count == 0){
            pendingPositionsResult = RealmManager.getInstance().realm.objects(Position.self).sorted(byKeyPath: "date")
            
        }else{
            let mostRecentPosition = historyPositions[0]
            pendingPositionsResult = RealmManager.getInstance().realm.objects(Position.self).filter("date > %@", mostRecentPosition.date).sorted(byKeyPath: "date")
        }

        for newPosition in pendingPositionsResult{
            if (newPosition.geocodedAddress.count == 0){
                self.geocodePosition(position: newPosition)
            }
            self.historyPositions.insert(newPosition, at: 0)
            self.historyTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        }
        
    }
    
    //MARK: - Geocoding methods
    func geocodePosition(position: Position){
        APIService.getAddressForLatLng(latitude: position.lat, longitude: position.lng) { (address, error) in
            if(error == nil && address.count > 0){
                try! RealmManager.getInstance().realm.write {
                    position.geocodedAddress = address
                }
                self.updatePositionInTable(position: position)
            }else{
//                Just give up
            }
        }
    }
    
}
