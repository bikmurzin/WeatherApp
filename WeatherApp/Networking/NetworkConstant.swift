////   /*
//
//  Project: WeatherApp
//  File: NetworkConstant.swift
//  Created by: Robert Bikmurzin
//  Date: 11.10.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation

class NetworkConstant {
    public static var shared: NetworkConstant = NetworkConstant()
    
    private init() {
        // Singletone
    }
    
    public var apiKey: String {
        get {
            // API key
            return "13a33900751abf85e9233aa3540caab8"
        }
    }
    
    public var serverAddress: String {
        get {
            return "https://api.openweathermap.org/"
        }
    }
    
    public var currentWeatherAddress: String {
        get {
            return self.serverAddress + "data/2.5/weather"
        }
    }
    
    public var weekWeatherAddress: String {
        get {
            return self.serverAddress + "data/2.5/forecast"
        }
    }
    
    public var geocodingAddress: String {
        get {
            return self.serverAddress + "geo/1.0/direct"
        }
    }
}
