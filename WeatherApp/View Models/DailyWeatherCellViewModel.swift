////   /*
//
//  Project: WeatherApp
//  File: WeekWeatherViewModel.swift
//  Created by: Robert Bikmurzin
//  Date: 13.10.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation

class DailyWeatherCellViewModel {
    
    private var dayWeatherForecast: [OneHourForecast] = []
    var maxDailyTemp: String
    var minDailyTemp: String
    var date: String
    var imageName: String
    var dayOfWeek: String
    
    init(for dayWeatherForecast: [OneHourForecast]) {
        self.dayWeatherForecast = dayWeatherForecast
        
        if let mostColdHour = dayWeatherForecast.max(by: {
            return $0.main.temp > $1.main.temp
        }) {
            self.minDailyTemp = mostColdHour.main.temp.prepareToShowDegrees()
        } else { minDailyTemp = "" }
        
        if let mostWarmHour = dayWeatherForecast.max(by: {
            return $0.main.temp < $1.main.temp
        }) {
            self.maxDailyTemp = mostWarmHour.main.temp.prepareToShowDegrees()
        } else {
            maxDailyTemp = ""
        }
        
//        if let imageName = middayHour().weather[0].icon {
//            self.imageName = imageName
//        } else {
//            self.imageName = ""
//        }
        imageName = "tmpIcon"
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        self.date = dateFormatter.string(from: dayWeatherForecast[0].dt)
        
        dateFormatter.dateFormat = "EEEE"
        dayOfWeek = dateFormatter.string(from: dayWeatherForecast[0].dt)
    }
    
    func middayHour() -> OneHourForecast {
        // Реализация поиска середины дня
        return dayWeatherForecast[0]
    }
    
}
