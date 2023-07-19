//
//  ProtocolImplementation.swift
//  WeatherApp
//
//  Created by User on 19.07.2023.
//

import Foundation
import UIKit

// MARK: ViewControllerDelegateForModel
extension ViewController: ViewControllerDelegateForModel {
    
    func showCurrentWeather() {
        //        titleLabel.text = "Самара"
        //        currentTemperature.text = "+8°"
        //        weatherIcon.image = UIImage(named: "11d")
        //        weatherDescription.text = "Гроза"
        DispatchQueue.main.async {
            if let description = self.weatherData.currentWeather?.weather[0].description {
                self.weatherDescription.text = description
            }
            
            if let icon = self.weatherData.currentWeather?.weather[0].icon {
                self.weatherIcon.image = UIImage(named: icon)
            }
            
            self.titleLabel.text = "Самара"
            if let temp = self.weatherData.currentWeather?.main.temp {
                
                if temp > 0 {
                    self.currentTemperature.text = "+\(Int(temp))°"
                } else if temp < 0 {
                    self.currentTemperature.text = "-\(Int(temp))°"
                } else {
                    self.currentTemperature.text = "\(Int(temp))°"
                }
            }
            self.configureView()
        }
    }
    
    func showFiveDaysWeather() {
        DispatchQueue.main.async {
            self.showHourlyWeather()
            self.fiveDaysWeatherView.fiveDaysCollectionView.reloadData()
        }
    }
    
    func showHourlyWeather() {
        hourlyWeatherView.hourlyWeatherCollectionView.reloadData()
    }
    
}

//MARK: ViewControllerDelegateForHourlyWeatherView
extension ViewController: ViewControllerDelegateForHourlyWeatherView, ViewControllerDelegateForFiveDaysWeatherView {
    func getFiveDaysWeather() -> [OneDayWeather] {
        weatherData.fiveDaysWeatherArray
    }
    
    
    func getHourlyWeather() -> [OneHourWeather] {
        weatherData.hourlyWeatherArray
    }
    
}
