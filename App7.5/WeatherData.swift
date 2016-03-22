//
//  WeatherData.swift
//  App7.5
//
//  Created by Kipras on 3/21/16.
//  Copyright © 2016 Kipras. All rights reserved.
//

import UIKit

// Class for the data api returns.
class WeatherData {
    
    let city: String
    let temperature: Double
    let description: String
    let weatherIcon: String
    let clouds: Double
    let wind: Double
    let humidity: Double
    
    init(city: String, temperature: Double, description: String, weatherICon: String, clouds: Double, wind: Double, humidity: Double) {
        
        self.city = city
        self.temperature = temperature
        self.description = description
        self.weatherIcon = weatherICon
        self.clouds = clouds
        self.wind = wind
        self.humidity = humidity
    }
    
    // Converts temperature to celcius.
    var celcius: Double {
        get {
            return temperature - 273.15
        }
    }
}
