//
//  NetworkingGateway.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 28/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit
import Alamofire

class NetworkingGateway: NSObject {
    static let shared = NetworkingGateway()
    
    static private let manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 30
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    static func executeGetRequestReceiveJson (url: String, completionHandler: @escaping(_ jsonDict: [String:Any]?, _ success: Bool, _ error: Error?, _ status: Int) -> ()) {
        NetworkingGateway.printRequest(url:url, method: "GET" ,parameters:[:])
        manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    guard response.result.isSuccess else {
                        ConsolePrinter.printToConsole(output: String(format:"Error with response: %@", response.result.isFailure.description))
                        completionHandler(nil, false, response.error!, status)
                        return
                    }
                    NetworkingGateway.printResponse(url: url, bodyResponse: response.result.value.debugDescription)
                    guard let responseJSON = response.result.value as? [String : Any] else{
                        ConsolePrinter.printToConsole(output: String(format:"Error parsing json: %@", response.result.value.debugDescription))
                        completionHandler(nil, false, nil, status)
                        return
                    }
                    completionHandler(responseJSON, true, nil, status)
                    break
                default:
                    ConsolePrinter.printToConsole(output: String(format: "Error. For request the statusCode is: %i", status))
                    completionHandler(nil, false, nil, status)
                    break
                }
            }else{
                ConsolePrinter.printToConsole(output: "StatusCode???")
                completionHandler(nil, false, nil, 0)
            }
        }
    }
    
    static func executePostRequestReceiveJson (url: String, parameters: [String : Any], completionHandler: @escaping(_ jsonDict: [String:Any]?, _ success: Bool, _ error: Error?, _ status: Int) -> ()) {
        NetworkingGateway.printRequest(url:url, method: "POST" ,parameters:parameters)
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    guard response.result.isSuccess else {
                        ConsolePrinter.printToConsole(output: String(format:"Error with response: %@", response.result.isFailure.description))
                        completionHandler(nil, false, response.error!, status)
                        return
                    }
                    NetworkingGateway.printResponse(url: url, bodyResponse: response.result.value.debugDescription)
                    guard let responseJSON = response.result.value as? [String : Any] else{
                        ConsolePrinter.printToConsole(output: String(format:"Error parsing json: %@", response.result.value.debugDescription))
                        completionHandler(nil, false, nil, status)
                        return
                    }
                    completionHandler(responseJSON, true, nil, status)
                    break
                default:
                    ConsolePrinter.printToConsole(output: String(format: "Error. For request the statusCode is: %i", status))
                    completionHandler(nil, false, nil, status)
                    break
                }
            }else{
                ConsolePrinter.printToConsole(output: "StatusCode???")
                completionHandler(nil, false, nil, 0)
            }
        }
    }
    
    //Mark: - Debugging info
    static func printRequest(url: String, method: String,parameters : [String:Any]){
        ConsolePrinter.printToConsole(output: String(format:"Executing [%@] on [%@] with parameters: [%@]", method, url, parameters.description))
    }
    
    static func printResponse(url: String, bodyResponse : String){
        ConsolePrinter.printToConsole(output: String(format:"For:[%@] Answer: [%@]", url, bodyResponse))
    }
}
