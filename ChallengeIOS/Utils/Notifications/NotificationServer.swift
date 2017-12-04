//
//  NotificationServer.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 20/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit

enum NotificationType: String{
    case NewPosition = "NewPosition"
}

protocol NotificationHandlerDelegate{
    func handleNotification(notification : NotificationType)
}

class NotificationServer: NSObject {
    private static var sharedInstance: NotificationServer?
    
    private var subscriptions : [NotificationType : [NotificationHandlerDelegate?]]
    
    override init() {
        subscriptions = [:]
    }

    //MARK: - Singleton methods
    class func getInstance() -> NotificationServer{
        if(sharedInstance == nil){
            sharedInstance = NotificationServer()
        }
        
        return sharedInstance!
    }
    
    //MARK: - server methods
    func subscribe(handler: NotificationHandlerDelegate, forEvent: NotificationType){
        var handlersForEvent = subscriptions[forEvent]
        if(handlersForEvent == nil){
            handlersForEvent = []
            handlersForEvent!.append(handler)
            subscriptions[forEvent] = handlersForEvent
        }else{
            handlersForEvent!.append(handler)
        }
        
    }
    
    func notify(event: NotificationType){
        let handlersForEvent = subscriptions[event]
        if(handlersForEvent != nil){
            for handler in handlersForEvent!{
                handler?.handleNotification(notification: event)
            }
        }
    }
}
