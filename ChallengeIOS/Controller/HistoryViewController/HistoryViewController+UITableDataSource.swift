//
//  HistoryViewController+UITableDataSource.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 18/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit
import RealmSwift

extension HistoryViewController: UITableViewDataSource{
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
         return self.historyPositions.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PositionTableViewCell.cellIdentifier, for: indexPath) as? PositionTableViewCell else{
            fatalError("Not possible to dequeue PositionTableViewCell")
        }
        let position = historyPositions[indexPath.row]
        cell.presentPosition(position: position)
        position.tableViewCell = cell
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return false
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool{
        return false
    }

    public func sectionIndexTitles(for tableView: UITableView) -> [String]?{
        return nil
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int{
        return 1
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
    }

    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        
    }
}
