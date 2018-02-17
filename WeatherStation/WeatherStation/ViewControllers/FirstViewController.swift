//
//  FirstViewController.swift
//  WeatherStation
//
//  Created by Mark Filter on 2/16/18.
//  Copyright © 2018 Mark Filter. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {

    // Mark: - Outlets & Variables
    public let TAG: String = "FirstViewController.TAG"
    @IBOutlet var tableView : UITableView!
    @IBOutlet var labelStaticDay: UILabel!
    @IBOutlet var labelStaticWeather: UILabel!
    @IBOutlet var labelCityName : UILabel!
    @IBOutlet var labelTemp : UILabel!
    @IBOutlet var labelWeather : UILabel!
    @IBOutlet var textFieldStateToSearch : UITextField!
    var state : String = ""
    var city : String = ""
    var requestedURL : URL? = nil
    var cities : [String] = []
    var weatherImageUrl : String = ""
    var forecastData : [(title: String, forecast: String, icon: String)] = [(title: String, forecast: String, icon: String)]()
    
    
    // Mark: - View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Titles
        title = "Cities"
        if let tabBarController = self.tabBarController {
            tabBarController.viewControllers![1].title = "Forecast Details"
        }
        
        // Set Delegates
        tableView.delegate = self
        tableView.dataSource = self
        if let tabBarController = self.tabBarController {
            tabBarController.delegate = self
        }
        
        // Clear Unpopulated UI Elements
        clearUILabels()
        
        // Initialize with the state of Florida
        state = "FL"
        textFieldStateToSearch.text = "FL"
        fetchCitiesInFlorida(state: "FL")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Verify Network Connection
        NetworkUtils.checkConnection(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Mark: - TableView Data Source Callback Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.TABLE_VIEW_REUSE_ID_VC1, for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = cities[indexPath.row]
        
        return cell
    }


    // Mark: - TableView Delegate Callback Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        self.city = cities[row]
        self.getWeatherData(state: state, city: cities[row])
    }
    
    // Mark: - Custom Methods
    func clearUILabels() {
        labelStaticDay.alpha = 0.0
        labelStaticWeather.alpha = 0.0
        labelCityName.text = ""
        labelWeather.text = ""
        labelTemp.text = ""
    }
    
    func fetchCitiesInFlorida(state: String) {
        requestedURL = URL.init(string: "https://api.wunderground.com/api/d2e77b807eb40e20/forecast/q/\(state).json")
        if let url = requestedURL {
            NetworkUtils.fetchJSONFrom(requestUrl: url, delegate: self)
        }
        
    }
    
    
    func getWeatherData(state: String, city: String) {
        Log.i(TAG: TAG, message: "City = \(city), \(state)")
        
        if let cityString: String = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            Log.i(TAG: TAG, message: "cityString = " + cityString)
            requestedURL = URL.init(string: "https://api.wunderground.com/api/d2e77b807eb40e20/forecast/q/\(state)/\(cityString).json")
            if let requestedURL = requestedURL {
                NetworkUtils.fetchJSONFrom(requestUrl: requestedURL, delegate: self)
            }
        }
        
    }
    
    func loadTableViewWithCities(cityData: [String: Any]) {
        if let responseContents = cityData["response"] as? [String : Any] {
            if let results = responseContents["results"] as? [[String:Any]] {
                self.cities.removeAll()
                for index in 0..<results.count {
                    if let cityName = results[index]["city"] as? String {
                        self.cities.append(cityName)
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                Log.d(TAG: TAG, message: "Error getting data from cityData[\"response\"] in func loadTableViewWithCities(cityData: [String: Any])")
            }
        } else {
            Log.d(TAG: TAG, message: "Error getting data from weatherData[\"forecast\"] in func loadTableViewWithCities(cityData: [String: Any])")
        }
    }
    
    
    
    
    
    
    func updateUI(weatherData : [String: Any], city: String, state: String) {
        labelStaticDay.alpha = 1.0
        labelStaticWeather.alpha = 1.0
        if let outerForecastData = weatherData["forecast"] as? [String : Any] {
            
            if let txt_forecast = outerForecastData["txt_forecast"] as? [String : Any] {
                
                if let forecastday = txt_forecast["forecastday"] as? [Any] {
                    for index in 0..<forecastday.count {
                        
                        if let forecastForToday = forecastday[index] as? [String: Any] {
                            
                            if let forcastString = forecastForToday["fcttext"] as? String, let tempString = forecastForToday["title"] as? String, let iconUrlString = forecastForToday["icon_url"] as? String {
                                self.forecastData.append((title: tempString, forecast: forcastString, icon: iconUrlString))
                                self.labelCityName.text = "\(city), \(state)"
                                self.labelWeather.text = forecastData[0].forecast
                                self.labelTemp.text = forecastData[0].title
                                self.weatherImageUrl = forecastData[0].icon
                            }
                            else {
                                Log.d(TAG: TAG, message: "There was an error getting weather data for \(city), \(state)")
                            }
                        }
                        else {
                            Log.i(TAG: TAG, message: "Could not find object for key forecastday[0]")
                        }
                    }
                
                }
                else {
                    Log.i(TAG: TAG, message: "Could not find object for key forecastday")
                }
            }
            else {
                Log.i(TAG: TAG, message: "Could not find object for key txt_forecast")
            }
        }
        
        if self.forecastData.count != 0 {
            if let tabBarController = self.tabBarController {
                if (tabBarController.viewControllers != nil) && (tabBarController.viewControllers!.count > 1) {
                    if let secondViewController = tabBarController.viewControllers![1] as? SecondViewController {
                        secondViewController.forecastData = self.forecastData
                    }
                }
            }
        }
    }
    
}

extension FirstViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Log.i(TAG: TAG, message: "textFieldShouldReturn")
        if textFieldStateToSearch.text != nil {
            state = textFieldStateToSearch.text!
            fetchCitiesInFlorida(state: state)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        Log.i(TAG: TAG, message: "textFieldDidEndEditing")
    }
}

extension FirstViewController : NetworkUtilsRESTDelegate {
    
    func fetchJSONComplete(json: [String : Any], requestUrl: URL) {
        
        let urlSaveCity : String = self.city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        DispatchQueue.main.async {
            switch requestUrl {
            case URL.init(string: "https://api.wunderground.com/api/d2e77b807eb40e20/forecast/q/\(self.state).json")!:
                self.loadTableViewWithCities(cityData: json)
            case URL.init(string: "https://api.wunderground.com/api/d2e77b807eb40e20/forecast/q/\(self.state)/\(urlSaveCity).json")!:
                self.updateUI(weatherData: json, city: self.city, state: self.state)
            default:
                break
            }
        }
        
    }
    
    
}
