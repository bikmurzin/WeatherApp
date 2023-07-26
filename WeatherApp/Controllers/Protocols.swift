//
//  Protocols.swift
//  WeatherApp
//
//  Created by User on 19.07.2023.
//

import Foundation

// MARK: Protocols
protocol ViewControllerDelegateForModel: AnyObject {
    func showCurrentWeather()
    
    func showFiveDaysWeather()
}

protocol ViewControllerDelegateForHourlyWeatherView: AnyObject {
    func getHourlyWeather() -> [OneHourWeather]
}

protocol ViewControllerDelegateForFiveDaysWeatherView: AnyObject {
    func getFiveDaysWeather() -> [OneDayWeather]
}

protocol ViewControllerDelegateForCitySelection: AnyObject {
    func changeCity(newCity: City)
}
