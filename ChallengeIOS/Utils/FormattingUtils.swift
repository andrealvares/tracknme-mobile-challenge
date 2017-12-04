//
//  FormattingUtils.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 21/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit

class FormattingUtils: NSObject {
    private static var sharedInstance: FormattingUtils?
    var dateFormatter: DateFormatter
    
    override init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yy HH:mm:ss"
    }
    
    class func getInstance() -> FormattingUtils{
        if(sharedInstance == nil){
            sharedInstance = FormattingUtils()
        }
        
        return sharedInstance!
    }
    
    func formatDate(date: Date) -> String{
        return dateFormatter.string(from:date)
    }
}
