//
//  ViewController.swift
//  Clock_FinalProject
//
//  Created by Bijay Maharjan on 11/27/19.
//  Copyright © 2019 Bijay Maharjan. All rights reserved.
//

// Used extra library
// Alamofire - makes http request easy for API.
// SwiftyJSON - easily parse JSON file.
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

// Declare weather model before class, so that another class can access it.
let weatherDataModel = WeatherDataModel()

class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {

    // Variables.
    @IBOutlet weak var clockShort: UIImageView!
    @IBOutlet weak var clockLong: UIImageView!
    @IBOutlet weak var clockSecond: UIImageView!
    @IBOutlet weak var gearRight: UIImageView!
    @IBOutlet weak var gearLeft: UIImageView!
    @IBOutlet weak var gearSmall: UIImageView!
    @IBOutlet weak var gearBlurred1: UIImageView!
    @IBOutlet weak var gearBlurred2: UIImageView!
    @IBOutlet weak var gearBlurred3: UIImageView!
    @IBOutlet weak var globe: UIImageView!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelDayName: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var timer1:Timer?
    var timer2:Timer?
    let bmClock:BM_Clock = BM_Clock()
    
    var displayDate:Bool = true
    
    // Constants for API call.
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "44369c0ad84354b121e858ff575df9fb"
    
    // Declare variables.
    let locationManager = CLLocationManager()
    
    // Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial time and date setup.
        self.bmClock.updateTime(clockShort: self.clockShort,
                                clockLong: self.clockLong,
                                clockSecond: self.clockSecond,
                                gearSmall: self.gearSmall,
                                gearLeft: self.gearLeft,
                                gearRight: self.gearRight,
                                gearBlurred1: self.gearBlurred1,
                                gearBlurred2: self.gearBlurred2,
                                gearBlurred3: self.gearBlurred3,
                                meterHand: self.globe,
                                labelDay: self.labelDay,
                                labelDayName: self.labelDayName)
        
        // Creates timer to fire every second.
        timer1 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.bmClock.updateTime(clockShort: self.clockShort,
                                    clockLong: self.clockLong,
                                    clockSecond: self.clockSecond,
                                    gearSmall: self.gearSmall,
                                    gearLeft: self.gearLeft,
                                    gearRight: self.gearRight,
                                    gearBlurred1: self.gearBlurred1,
                                    gearBlurred2: self.gearBlurred2,
                                    gearBlurred3: self.gearBlurred3,
                                    meterHand: self.globe,
                                    labelDay: nil,
                                    labelDayName: nil)
    }
        
        // Set up location manager.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    // Networks -- connect to the API server
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success")
                let weatherJSON: JSON = JSON(response.result.value!)
                print("Debug: \(weatherJSON)")
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Failed"
            }
        }
    }
    
    // JSON Parsing
    // UpdateWeather
    func updateWeatherData(json: JSON) {
        
        if let tempResult = json["main"]["temp"].double {
            // Formula to conver kelvin to farhenheit.
            // (K - 273.15) * (9/5) + 32
            weatherDataModel.temperature = Int((tempResult - 273.15) * (9/5) + 32)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.timeZone = json["timezone"].intValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            // Call update
            updateUIWithWeatherData()
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    // Update UI
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature) ℉"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
//        weatherIcon.image = UIImage(named: "snow4")
    }
    
    
    // didUpdateLocation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingHeading()
            locationManager.delegate = nil
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String: String] = ["lat": latitude, "lon": longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
            
        }
    }
    
    //didFailWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    // UserEnteredANewCityName Delegate method.
    func userEnteredANewCityName(city: String) {
        let params: [String: String] = ["q": city, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    // PrepareForSegue Method.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecondScreen" {
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.delegate = self
        }
    }
    
    // Press button.
    @IBAction func buttonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSecondScreen", sender: self)
    }
    
}


