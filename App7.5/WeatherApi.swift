//
//  WeatherApi.swift
//  App7.5
//
//  Created by Kipras on 3/21/16.
//  Copyright © 2016 Kipras. All rights reserved.
//

import UIKit
import CoreLocation

// Delegate protocol to communicate between weatherApi and viewController.
protocol WeatherApiDelegate {
    
    func displayWeatherData(weatherData: WeatherData)
    func apiError(message: String)
    
}

class WeatherApi {
    
    var delegate: WeatherApiDelegate?
    
    // Accesses api by location.
    func weatherByLocation(location: CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let path = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=484a2592e23a8cb17aa4119b020d0709"
        callWeatherApi(path)
    }
    
    // Accesses api by city name.
    func weatherByCity(city: String) {
        if let formatedCityName = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()) {
            let path = "http://api.openweathermap.org/data/2.5/weather?q=\(formatedCityName)&appid=484a2592e23a8cb17aa4119b020d0709"
            callWeatherApi(path)
        }
    }

    
    // Requests api for weather data.
    func callWeatherApi (path: String) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            var status: Int?
            let response = response as? NSHTTPURLResponse
            
            // Checks whether api returns a good response.
            if response?.statusCode != 200 && response?.statusCode != 429 {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.delegate?.apiError("Service currently unavailable")
                })
            }
            
            // Extracts json data using SwiftyJSON.
            let json = JSON(data: data!)
            
            // Extracts status code from the json that api sends.
            if let statusCode = json["cod"].int {
                status = statusCode
            } else if let statusCode = json["cod"].string {
                status = Int(statusCode)!
            }
            
            // If api returns 200, data queried was found, it is initialized.
            if status == 200 {
                let city = json["name"].string!
                let temperature = json["main"]["temp"].double!
                let description = json["weather"][0]["description"].string!
                let weatherIcon = json["weather"][0]["icon"].string!
                let clouds = json["clouds"]["all"].double!
                let wind = json["wind"]["speed"].double!
                let humidity = json["main"]["humidity"].double!
                
                let weather = WeatherData(city: city, temperature: temperature, description: description, weatherICon: weatherIcon, clouds: clouds, wind: wind, humidity:  humidity)
                
                if self.delegate != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.displayWeatherData(weather)
                    })
                }
            }
                
            // If api returns 404, queried request was not found, display error message.
            else if status == 404 {
                if self.delegate != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.apiError("No city by such name, please try again")
                    })
                }
            }
            
            // If status code returned by api not 200 and not 404, display unknown error message.
            else if status != nil {
                if self.delegate != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.apiError("Something went wrong")
                    })
                }
            }
        }
        task.resume()
    }
}
