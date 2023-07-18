//
//  Model.swift
//  WeatherApp
//
//  Created by User on 27.06.2023.
//

import Foundation
import UIKit

struct List: Decodable {
    var dt: Date //Дата прогноза, unix, UTC
    var main: Main
    var weather: [Weather]
    var wind: Wind
    var pop: Double //вероятность осадков
    var sys: fiveDaysSys //часть суток (n- ночь, d - день)
    var dt_txt: String //Прогнозируемое время данных, ISO, UTC
}

struct currentSys: Decodable {
    var sunrise: Int //Время восхода солнца, unix, UTC
    var sunset: Int  //Время захода солнца, unix, UTC
}

struct fiveDaysSys: Decodable {
    var pod: String   //часть суток (n- ночь, d - день)
}

struct Main: Decodable {
    var temp: Double   //Температура
    var feelsLike: Double //Ощущается как
    var humidity: Double   //Влажность, %
    var grndLevel: Double //Атмосферное давление на уровне земли
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity
        case feelsLike = "feels_like"
        case grndLevel = "grnd_level"
    }
}

struct Weather: Decodable {
    var main: String    //Группа погодных параметров (Дождь, Снег, Экстрим и т.д.)
    var description: String     //Погодные условия в группе. Вы можете получить вывод на своем языке
    var icon: String    //Идентификатор значка погоды
}

struct Wind: Decodable {
    var speed: Double  //Скорость ветра. Единица измерения по умолчанию: метр/сек, метрическая система: метр/сек, британская система: мили/час
    var deg: Double    //Направление ветра, градусы (метеорологические)
    var gust: Double   //Порыв ветра. Единица измерения по умолчанию: метр/сек, метрическая система: метр/сек, британская система: мили/час
}



// MARK: Struct for displaying data
struct OneHourWeather {
    let time: String
    let temp: String
    let feelsLike: String
    let icon: UIImage?
}
