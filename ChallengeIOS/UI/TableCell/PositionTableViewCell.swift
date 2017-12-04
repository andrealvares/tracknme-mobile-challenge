//
//  PositionTableViewCell.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 18/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit

class PositionTableViewCell: UITableViewCell {
    static let cellIdentifier = "PositionTableViewCell"
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var noWifi: UIImageView!
    
    var position : Position?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Cell management
    func presentPosition(position: Position){
        self.position = position
        self.noWifi.isHidden = position.postedToBackend
        
        self.timeLabel.text = FormattingUtils.getInstance().formatDate(date: position.date)
        if(position.geocodedAddress.count > 0){
            self.addressLabel.text = position.geocodedAddress
        }else{
            self.addressLabel.text = String(format: "%f , %f", position.lat, position.lng)
        }
        
    }
    
    func updateAddress(){
        if(position != nil && (position!.geocodedAddress.count) > 0){
            self.addressLabel.text = position!.geocodedAddress
            ConsolePrinter.printToConsole(output: String(format: "Just set address %@", position!.geocodedAddress))
        }
    }
    
}
