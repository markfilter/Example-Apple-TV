//
//  NetworkUtils.swift
//  WeatherStation
//
//  Created by Mark Filter on 2/17/18.
//  Copyright © 2018 Mark Filter. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

class NetworkUtils {

    internal static let TAG : String = "NetworkUtils.TAG"
    static let opt_url : URL? = URL.init(string: "https://api.wunderground.com/")

    
    internal static func checkConnection(viewController: UIViewController, testValue: Bool) {

        var errorMessage = ""
        
        // MARK: - ErrorCode 501
        guard let url = opt_url else {
            Log.d(TAG: "Reachability.checkConnection(:_)", message: "Error creating URL to check for connection status")
            errorMessage = "Error creating URL to check for connection status. Error Code 501."
            self.displayErrorMessage(viewController: viewController, title: "No Internet Connection", errorMessage: errorMessage)
            return
        }
        
        // MARK: - ErrorCode 502
        let getData = URLSession.shared.dataTask(with: url) {
            (opt_data, opt_response, opt_error) in
            if let error = opt_error {
                Log.d(TAG: self.TAG, message: error.localizedDescription)
                errorMessage = error.localizedDescription + " Error Code 502."
                self.displayErrorMessage(viewController: viewController, title: "No Internet Connection", errorMessage: errorMessage)
                return
            }
            
            // MARK: - ErrorCode 503
            guard let httpResponse = opt_response as? HTTPURLResponse
            else {
                print("Error getting a response from the server")
                errorMessage = "Error getting a response from the server. Error Code 503."
                self.displayErrorMessage(viewController: viewController, title: "Degraded Internet Connection", errorMessage: errorMessage)
                return
            }
            
            
            
            switch httpResponse.statusCode {
                case 200:
                    break
                case 500:
                    self.displayErrorMessage(viewController: viewController, title: "Degraded Internet Connection", errorMessage: "You are connected to the internet, but the server is not responding.")
                default:
                    self.displayErrorMessage(viewController: viewController, title: "No Internet Connection", errorMessage: "Please check your internet connection and try again.")
            }
            
            
        }
        getData.resume()
        
        
    }
    
    
    internal static func displayErrorMessage(viewController: UIViewController, title: String, errorMessage: String) {
        
        let alertController: UIAlertController = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
        
    }
}

