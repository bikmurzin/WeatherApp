////   /*
//
//  Project: WeatherApp
//  File: CurrentWeatherViewModel.swift
//  Created by: Robert Bikmurzin
//  Date: 12.10.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation

class CurrentWeatherViewModel {
    private var cityName: String
    private var currentTemp: String
    private var imageName: String
    private var weatherDescription: String
    
    init(currentWeather: CurrentWeatherModel) {
        self.cityName = "Москва"
        if let currentTemp = currentWeather.main.temp {
            self.currentTemp = String(currentTemp)
        } else {
            self.currentTemp = "--"
        }
        self.imageName = currentWeather.weather[0].icon ?? ""
        self.weatherDescription = currentWeather.weather[0].description ?? "--"
    }
    
    func getCityName() -> String {
        cityName
    }
    
    func getCurrentTemp() -> String{
        let temp = Int(Double(currentTemp) ?? 0)
        var stringTemp = String(temp)
        if temp != 0 {
            if temp > 0 {
                stringTemp = "+\(stringTemp)"
            } else {
                stringTemp = "-\(stringTemp)"
            }
        }
        return stringTemp
    }
    
    func getDescription() -> String {
        weatherDescription
    }
    
    func getImageName() -> String {
        imageName
    }
}
