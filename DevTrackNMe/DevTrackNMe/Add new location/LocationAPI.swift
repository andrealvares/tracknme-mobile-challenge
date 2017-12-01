//
//  LocationAPI.swift
//  DevTrackNMe
//
//  Created by Thales Frigo on 01/12/17.
//  Copyright © 2017 Thales Frigo. All rights reserved.
//

import Foundation
import Moya

enum LocationAPI {
    case create(coordinate: Coordinate)
}

extension LocationAPI: TargetType {
    
    var baseURL: URL {
        return Bundle.main.apiaryAPIUrl
    }
    
    var path: String {
        return "coordinates"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var task: Task {
        switch self {
        case .create(let coordinate):
            return .requestParameters(parameters: coordinate.toJSON().dictionaryObject!, encoding: parameterEncoding)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
