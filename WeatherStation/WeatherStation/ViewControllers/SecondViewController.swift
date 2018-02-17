//
//  SecondViewController.swift
//  WeatherStation
//
//  Created by Mark Filter on 2/16/18.
//  Copyright © 2018 Mark Filter. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Mark: - Outlets and Variables
    public let TAG: String = "SecondViewController.TAG"
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imageViewIcon: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelForecast: UILabel!
    
    
    var forecastData : [(title: String, forecast: String, icon: String)] = [(title: String, forecast: String, icon: String)]()

    // Mark: View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        labelTitle.text = ""
        labelForecast.text = ""
        self.title = "Forecast Details"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        updateTableView()
    }
    
    
    // Mark: - TableView Data Source Callback Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.TABLE_VIEW_REUSE_ID_VC2, for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = forecastData[indexPath.row].title
        
        return cell
    }
    
    
    // Mark: - TableView Delegate Callback Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        self.loadImage(at: row)
    }
    
    // Mark: - Custom Methods
    
    func updateTableView() {
        
    }
    
    
    func loadImage(at row: Int) {
        let forecastImageUrl = forecastData[row].icon
        Log.i(TAG: TAG, message: forecastImageUrl )
        
            if var url = URL.init(string: forecastImageUrl) {
                
                
                if url.scheme == "http" {
                    Log.i(TAG: TAG, message: "url.scheme = \(url.scheme ?? "no scheme")" )
                    Log.i(TAG: TAG, message: "url.host = \(url.host ?? "no host")" )
                    Log.i(TAG: TAG, message: "url.relativePath = \(url.relativePath)" )
                    let secureURLString : String = "https://" + url.host! + "/" + url.relativePath
                    url = URL.init(string: secureURLString)!
                }
                
                
                
                let getData = URLSession.shared.dataTask(with: url, completionHandler: { (opt_data, opt_response, opt_error) in
                    
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
                        self.imageViewIcon.image = UIImage.init(data: validData)
                        self.labelTitle.text = self.forecastData[row].title
                        self.labelForecast.text = self.forecastData[row].forecast
                    }
                    
                })
                getData.resume()
            }
            else {
                Log.d(TAG: self.TAG, message: "Error creating ImageView Icon Url in viewDidLoad()")
                Log.d(TAG: self.TAG, message: "\(forecastImageUrl )")
            }
            
        
    }


}

