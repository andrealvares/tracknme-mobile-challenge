//
//  ConsolePrinter.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 28/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit

class ConsolePrinter: NSObject {
    static func printToConsole(output: String){
        #if DEBUG || PRINT_LOG
            print(output)
        #endif
    }
}
