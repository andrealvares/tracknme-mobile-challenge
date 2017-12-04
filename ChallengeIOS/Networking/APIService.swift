//
//  APIService.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 28/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit

class APIService: NSObject {
    //MARK: - Variables
    static let EndpointAddress : String! = "http://private-6d5bd-challengeios.apiary-mock.com"
    static let PositionPath : String! = "position"
    static let GoogleGeocodingAddress : String! = "https://maps.googleapis.com/maps/api/geocode/json?"
    static let GoogleGeocodingKey : String! = "AIzaSyAE-2_a8d3Ej5qSb60KVXabuDMjWeABg6o"
    
    static func postPosition(position: Position, completionHandler: @escaping(_ statusCode: Int, _ error: Error?) -> ()) {
        let url: String = String(format:"%@/%@", EndpointAddress, PositionPath)
        
        NetworkingGateway.executePostRequestReceiveJson(url: url, parameters: position.getDictionary()) { (jsonDict, success, error, status) in
            if(success && error == nil){
                if(status == 200 && jsonDict != nil){
                    let statusCodeBodyNumber: NSNumber = jsonDict!["statusCode"] as? NSNumber ?? NSNumber(integerLiteral: -1)
                    completionHandler(statusCodeBodyNumber.intValue, error)
                }else{
                    completionHandler(status, error)
                }
            }else{
                completionHandler(-1, error)
            }
        }
    }
    
    static func getAddressForLatLng(latitude: Double, longitude: Double, completionHandler: @escaping(_ address: String, _ error: Error?) -> ()) {
        let url = String(format:"%@latlng=%f,%f&key=%@", GoogleGeocodingAddress, latitude, longitude, GoogleGeocodingKey)
        NetworkingGateway.executeGetRequestReceiveJson(url: url) { (responseDict, success, error, statusCode) in
            if(success && error == nil){
                
                var address = ""
                if let resultsArray = responseDict?["results"] as? [Any?]{
                    for result in resultsArray{
                        if let resultDict = result as? [String : Any?]{
                            var isTypeRoute = false
                            if let typesArray = resultDict["types"] as? [Any?]{
                                for type in typesArray{
                                    if let typeStr = type as? String{
                                        if (typeStr == "route" || typeStr == "street_address"){
                                            isTypeRoute = true
                                            break
                                        }
                                        
                                    }
                                }
                            }
                            if(isTypeRoute){
                                address = resultDict["formatted_address"] as? String ?? ""
                            }
                        }
                    }
                }
                
                ConsolePrinter.printToConsole(output: String(format:"address: %@", address))
                completionHandler(address, error)
            }
        }
    }
    
    
}
