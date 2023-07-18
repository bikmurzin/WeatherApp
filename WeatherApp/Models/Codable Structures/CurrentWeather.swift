//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by User on 06.07.2023.
//

import Foundation

struct CurrentWeather: Decodable {
    var weather: [Weather]
    var main: Main
    var wind: Wind    
    var dt: Date  //время расчета данных unix, UTC (секунды)
    var sys: currentSys
    var timezone: Int    //сдвиг от UTC в секундах
}
