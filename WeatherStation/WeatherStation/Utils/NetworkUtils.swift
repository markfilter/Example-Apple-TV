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

    /**
     Checks network connectivity by making a request to the domain's server. Handles alerting the user to connection issues.
     - Parameters:
     - viewController: The calling ViewController.
     - Author: Mark Filter
     */
    internal static func checkConnection(viewController: UIViewController) {

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
    
    /**
     Displays an error message in an AlertController.
     - Parameters:
     - viewController: The ViewController presenting the AlertController.
     - title: The title of the message
     - errorMessage: The message to display to the user that defines the error.
     - Author: Mark Filter
     */
    internal static func displayErrorMessage(viewController: UIViewController, title: String, errorMessage: String) {
        
        let alertController: UIAlertController = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
    /**
     Fetches JSON from the requested URL and returns the JSON via the delegate method.
     - Parameters:
     - requestUrl: The URL of the request.
     - delegate: The context registered for receiving callbacks.
     - Author: Mark Filter
     */
    internal static func fetchJSONFrom(requestUrl: URL, delegate: NetworkUtilsRESTDelegate) {
        
        let getData = URLSession.shared.dataTask(with: requestUrl) {
            (opt_data, opt_response, opt_error) in
            if let error = opt_error {
                Log.d(TAG: self.TAG, message: error.localizedDescription)
                return
            }
            guard let httpResponse = opt_response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let validData = opt_data
                else { print("JSON Object Creation Failed"); return }
            do {
                
                if let jsonObj = try JSONSerialization.jsonObject(with: validData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                    delegate.fetchJSONComplete!(json: jsonObj, requestUrl: requestUrl)
                }
                else {
                    Log.d(TAG: self.TAG, message: "error creating jsonObj")
                }
                
            }
            catch { print(error.localizedDescription) }
            
        }
        getData.resume()
        
    }
    
    
    /**
     Fetches Image data from the requested URL and returns the UIImage via the delegate method.
     - Parameters:
     - requestUrl: The URL of the request.
     - delegate: The context registered for receiving callbacks.
     - Author: Mark Filter
     */
    internal static func fetchImageFrom(url: URL, delegate: NetworkUtilsRESTDelegate) {
        var secureURL : URL = url
        if url.scheme == "http" {
            Log.i(TAG: TAG, message: "url.scheme = \(url.scheme ?? "no scheme")" )
            Log.i(TAG: TAG, message: "url.host = \(url.host ?? "no host")" )
            Log.i(TAG: TAG, message: "url.relativePath = \(url.relativePath)" )
            let secureURLString : String = "https://" + url.host! + "/" + url.relativePath
            secureURL = URL.init(string: secureURLString)!
        }
        
        let getData = URLSession.shared.dataTask(with: secureURL, completionHandler: { (opt_data, opt_response, opt_error) in
            
            if let error = opt_error {
                Log.d(TAG: self.TAG, message: error.localizedDescription)
                return
            }
            guard let httpResponse = opt_response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let validData = opt_data
                else {
                    Log.d(TAG: self.TAG, message: "Data was invalid")
                    return
                    
            }
            
            DispatchQueue.main.async {
                if let image = UIImage.init(data: validData) {
                    delegate.fetchImageComplete!(image: image, requestedUrl: url)
                }
            }
            
        })
        getData.resume()
    }
    
}


/**
 This protocol is for returning Network RESTful GET, POST, PUT, and DELETE calls made by the conforming entity.
 - Author: Mark Filter
 */
@objc internal protocol NetworkUtilsRESTDelegate {
    /**
     Returns a dictionary object of serialized JSON data of type [String: Any].
     - Parameters:
     - json: The serialized JSON data. [String:Any]
     - requestUrl: The URL used to make the request. Can be used in a Switch statement to handle multiple requests from the same requesting context.
     - Author: Mark Filter
     */
    @objc optional func fetchJSONComplete(json: [String:Any], requestUrl: URL)
    
    /**
     Returns a UImage object from hte requested URL address.
     - Parameters:
     - image: The UIImage initialized from the returned Data.
     - requestUrl: The URL used to make the request. Can be used in a Switch statement to handle multiple requests from the same requesting context.
     - Author: Mark Filter
     */
    @objc optional func fetchImageComplete(image: UIImage, requestedUrl: URL)
}

