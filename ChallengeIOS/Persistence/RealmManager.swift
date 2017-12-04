//
//  RealmManager.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 20/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager: NSObject {
    private static var sharedInstance: RealmManager?
    var realm : Realm
    
    override init() {
        realm = try! Realm()
    }
    
    class func getInstance() -> RealmManager{
        if(sharedInstance == nil){
            sharedInstance = RealmManager()
        }
        
        return sharedInstance!
    }
}
