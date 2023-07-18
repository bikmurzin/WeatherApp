//
//  FiveDaysWeather.swift
//  WeatherApp
//
//  Created by User on 06.07.2023.
//

import Foundation

struct FiveDaysWeather: Decodable {
    var cnt: Int //Количество временных меток, которые будут возвращены в ответе API
    var list: [List]
}
