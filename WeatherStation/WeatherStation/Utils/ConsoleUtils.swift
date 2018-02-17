//
//  ConsoleUtils.swift
//  WeatherStation
//
//  Created by Mark Filter on 2/16/18.
//  Copyright © 2018 Mark Filter. All rights reserved.
//

import Foundation

class Log {
    
    /**
     Displays informative output to the console.
     - Parameters:
       - TAG: The filter TAG to be used to isolate the textual information.
       - message: The message to be displayed in the console.
     - Author: Mark Filter
     */
    internal static func i(TAG: String, message: String) {
        print("i: ", TAG, ": ", message)
    }
    
    /**
     Displays debug output to the console.
     - Parameters:
       - TAG: The filter TAG to be used to isolate the textual information.
       - message: The message to be displayed in the console.
     - Author: Mark Filter
     */
    internal static func d(TAG: String, message: String) {
        print("d: ", TAG, ": ", message)
    }
    
}
