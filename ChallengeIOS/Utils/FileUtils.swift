//
//  FileUtils.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 17/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit

class FileUtils: NSObject {

    class func parseArrayFromJson(filename: String) -> Array<AnyObject>{
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let jsonArray = jsonResult as? Array<AnyObject>
                if (jsonArray != nil) {
                    return jsonArray!
                }
            } catch {
                // handle error
            }
        }
        return []
    }
}
