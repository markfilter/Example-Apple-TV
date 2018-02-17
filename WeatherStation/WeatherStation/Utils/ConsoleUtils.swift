//
//  ConsoleUtils.swift
//  WeatherStation
//
//  Created by Mark Filter on 2/16/18.
//  Copyright © 2018 Mark Filter. All rights reserved.
//

import Foundation

class Log {
    
    internal static func i(TAG: String, message: String) {
        print("i: ", TAG, ": ", message)
    }
    
    internal static func d(TAG: String, message: String) {
        print("d: ", TAG, ": ", message)
    }
    
}
