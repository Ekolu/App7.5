//
//  ViewController.swift
//  App7.5
//
//  Created by Kipras on 3/21/16.
//  Copyright © 2016 Kipras. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, WeatherApiDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.weatherApi.delegate = self
        // Sets background image.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bkg-7.png")!)
        // Location delegate authorization and iniatilization.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        // When app starts display data by user location.
        self.getGPSLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Users/Ekolu/Desktop/App7.5/App7.5/Base.lproj/LaunchScreen.storyboard/ Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var clouds: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var humidity: UILabel!

    // Initializing variables.
    let weatherApi = WeatherApi()
    let locationManager = CLLocationManager()
    
    // Weather api delegate transfers queried weather data and displays it.
    func displayWeatherData(weatherData: WeatherData) {
        let numberFormatter = NSNumberFormatter()
        cityName.text = weatherData.city
        temperature.text = "\(numberFormatter.stringFromNumber(weatherData.celcius)!)˚C"
        weatherDescription.text = weatherData.description
        wind.text = "Wind: \(numberFormatter.stringFromNumber(weatherData.wind)!)mph"
        weatherIcon.image = UIImage(named: weatherData.weatherIcon)
        clouds.text = "Cloudiness: \(numberFormatter.stringFromNumber(weatherData.clouds)!)%"
        humidity.text = "Humidity: \(numberFormatter.stringFromNumber(weatherData.humidity)!)%"
    }
    
    // Displays alert to query for data by city name.
    @IBAction func anotherCity(sender: AnyObject) {
        anotherCityAlert()
    }
    
    // Alert allows to query for data by city name.
    func anotherCityAlert() {
        let alert = UIAlertController(title: "New city", message: "Enter a city name", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let go = UIAlertAction(title: "Go", style: .Default) { (action: UIAlertAction) -> Void in
            let textField = alert.textFields![0]
            let city = textField.text
            self.weatherApi.weatherByCity(city!)
        }
        // Creates text field.
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.placeholder = "City, Country"
        }
        // Allows to query data by location.
        let location = UIAlertAction(title: "GPS", style: .Default) { (action: UIAlertAction) -> Void in
            self.getGPSLocation()
        }
        // Creates buttons
        alert.addAction(cancel)
        alert.addAction(go)
        alert.addAction(location)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Delegate error alert.
    func apiError(message: String) {
        let alert = UIAlertController(title: "Api Error", message: message, preferredStyle: .Alert)
        let okay = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        alert.addAction(okay)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // Functions to find user location.
    func getGPSLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.weatherApi.weatherByLocation(locations[0])
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        apiError("Failed to detect location")
    }

}