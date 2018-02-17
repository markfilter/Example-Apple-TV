//
//  FirstViewController.swift
//  WeatherStation
//
//  Created by Mark Filter on 2/16/18.
//  Copyright © 2018 Mark Filter. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Mark: - Outlets & Variables
    public let TAG: String = "FirstViewController.TAG"
    @IBOutlet var tableView: UITableView!
    @IBOutlet var labelCityName: UILabel!
    @IBOutlet var labelTemp: UILabel!
    @IBOutlet var labelWeather: UILabel!
    let state = "FL"
    var cities = ["Orlando","Jacksonville","Naples", "Miami", "Tampa"]
    
    
    // Mark: - View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup
        tableView.delegate = self
        tableView.dataSource = self
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
        self.getWeatherData(state: state, city: cities[row])
    }
    
    func getWeatherData(state: String, city: String) {
        Log.i(TAG: TAG, message: "City = \(city), \(state)")
        if let cityString: String = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            if let url = URL(string: "https://api.wunderground.com/api/d2e77b807eb40e20/forecast/q/\(state)/\(cityString)") {
                let getData = URLSession.shared.dataTask(with: url) {
                    (opt_data, opt_response, opt_error) in
                    if let error = opt_error {
                        Log.d(TAG: self.TAG, message: error.localizedDescription)
                        return
                    }
                    
                    if let data = opt_data {
                        DispatchQueue.main.async {
                            self.updateUI(weatherData: data)
                        }
                    }
                    
                }
                getData.resume()
            }
            
        }
        
    }
    
    func updateUI(weatherData : Data) {
        Log.i(TAG: TAG, message: String.init(describing: weatherData))
    }
}

