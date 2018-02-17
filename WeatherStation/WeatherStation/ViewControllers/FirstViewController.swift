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
    var cities = ["Austin","Dallas","Phoenix", "Portand", "San Diego"]
    
    
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
        self.getWeatherData(city: cities[row])
    }
    
    func getWeatherData(city: String) {
        Log.i(TAG: TAG, message: "City = \(city)")
    }
}

