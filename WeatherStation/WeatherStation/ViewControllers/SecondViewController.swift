//
//  SecondViewController.swift
//  WeatherStation
//
//  Created by Mark Filter on 2/16/18.
//  Copyright © 2018 Mark Filter. All rights reserved.
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge, publish, distribute,
//  sublicense, and/or sell coppies of the software and to permit persons to whome the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
//  NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NetworkUtilsRESTDelegate {
    
    // Mark: - Outlets and Variables
    public let TAG: String = "SecondViewController.TAG"
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imageViewIcon: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelForecast: UILabel!
    var selectedRow : Int = 0
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
        selectedRow = indexPath.row
        self.loadImage(at: selectedRow)
    }
    
    
    // Mark: - Custom Methods
    
    func loadImage(at row: Int) {
        let forecastImageUrl = forecastData[row].icon
        
            if let url = URL.init(string: forecastImageUrl) {
                NetworkUtils.fetchImageFrom(url: url, delegate: self)
            }
            else {
                Log.d(TAG: self.TAG, message: "Error creating ImageView Icon Url in viewDidLoad()")
                Log.d(TAG: self.TAG, message: "\(forecastImageUrl )")
            }
    }

    // MARK: - NetworkUtilsRESTDelegate Callbacks
    
    func fetchImageComplete(image: UIImage, requestedUrl: URL) {
        DispatchQueue.main.async {
            self.imageViewIcon.image = image
            self.labelTitle.text = self.forecastData[self.selectedRow].title
            self.labelForecast.text = self.forecastData[self.selectedRow].forecast
        }
    }

}

