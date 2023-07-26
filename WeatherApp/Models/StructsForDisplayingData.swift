//
//  StructsForDisplayingData.swift
//  WeatherApp
//
//  Created by User on 19.07.2023.
//

import Foundation
import UIKit

// MARK: Struct for displaying data
struct OneHourWeather {
    let time: String
    let temp: String
    let feelsLike: String
    let icon: String
    let pod: String
}

struct OneDayWeather {
    let date: String
    let tempMin: String
    let tempMax: String
    let icon: UIImage?
    let firstDayIndex: Int
    let dayOfTheWeek: String
}
