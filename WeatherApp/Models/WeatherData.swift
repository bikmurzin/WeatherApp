//
//  Request.swift
//  WeatherApp
//
//  Created by User on 27.06.2023.
//

import Foundation
import UIKit
import Alamofire



//lat=44.34&lon=10.99

class WeatherData {
    
    // Количество элементов, отображаемых в почасовой погоде
    // Выбрано значение 8, т.к. в JSON приходит погода с шагом в 3 часа (8 - это сутки)
    let countElementsInHourlyWeather = 8
    
    var hourlyWeatherArray: [OneHourWeather] = []
    
    // делегат ViewController для обновления данных
    weak var delegate: ViewControllerDelegateForModel?
    
    let apiData = APIData()
    
    var currentWeather: CurrentWeather?
    
    var fiveDaysWeather: FiveDaysWeather?
    
    var geocoding: Geocoding?
    
    func getCurrentWeather() -> CurrentWeather? {
        return currentWeather
    }
    
    func getFiveDaysWeather() -> FiveDaysWeather? {
        return fiveDaysWeather
    }
    
    func getGeocoding() -> Geocoding? {
        return geocoding
    }
    
    func fetchCurrentWeather(latitude: Double, longitude: Double) {
        
        let parameters = ["appid":apiData.apiKey, "lat": String(latitude), "lon": String(longitude), "units": "metric", "lang": "ru"]
        
        // запрашиваем эндпоинт
        AF.request(apiData.currentWeatherURL, parameters: parameters)
        
        // проверяем ответ, гарантируя, что ответ возвращает код состояния HTTP в диапазоне 200-299
            .validate()
        
        // декодируем ответ в модель данных
            .responseDecodable(of: CurrentWeather.self, queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
                
                guard let weather = response.value else {return}
                self.currentWeather = weather
                
                if let delegate = self.delegate {
                    delegate.showCurrentWeather()
                }
                
            }
        
    }
    
    func fetchFiveDaysWeather(latitude: Double, longitude: Double) {
        let parameters = ["appid":apiData.apiKey, "lat": String(latitude), "lon": String(longitude), "units": "metric", "lang": "ru"]
        AF.request(apiData.fiveDaysWeatherURL, parameters: parameters)
            .validate()
            .responseDecodable(of: FiveDaysWeather.self, queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
                guard let fiveDaysWeather = response.value else {
                    return
                }
                self.fiveDaysWeather = fiveDaysWeather
                
                self.fillingArrayWithHourlyWeather()
                
                if let delegate = self.delegate {
                    delegate.showFiveDaysWeather()
                }
            }
    }
    
    func fetchGeocoding(city: String) {
        let q = city + ",ru"
        let parameters = ["appid":apiData.apiKey, "q": q]
        AF.request(apiData.geocodingURL, parameters: parameters)
            .validate()
            .responseDecodable(of: Geocoding.self, queue: DispatchQueue.global(qos: .userInitiated)) { (response) in
                guard let geocoding = response.value else {
                    return
                }
                self.geocoding = geocoding
                self.fetchCurrentWeather(latitude: geocoding.geocoding[0].lat, longitude: geocoding.geocoding[0].lon)
                self.fetchFiveDaysWeather(latitude: geocoding.geocoding[0].lat, longitude: geocoding.geocoding[0].lon)
            }
    }
    
}

// MARK: processing data to pass it to ViewController
extension WeatherData {
    
    func fillingArrayWithHourlyWeather() {
        /*
         let time: String
         let temp: String
         let feelsLike: String
         let icon: UIImage
         */
        
        guard let list = fiveDaysWeather?.list else {return}
        
        var iterationCount = 0
        
        if list.count >= countElementsInHourlyWeather {
            iterationCount = countElementsInHourlyWeather
        } else {
            iterationCount = list.count
        }
        
            for i in 0..<iterationCount {
                
                let time = getTimeOnly(date: list[i].dt)
                // удаляем дробную часть и переводим в String
                let temp = String(Int(list[i].main.temp))
                let feelsLike = String(Int(list[i].main.feelsLike))
                let icon = UIImage(named: list[i].weather[0].icon)
                hourlyWeatherArray.append(OneHourWeather(time: time, temp: temp, feelsLike: feelsLike, icon: icon))
                
            }
    }
    
}

// MARK: Work with date
extension WeatherData {
    
    func getDateAndTime(date: Date) -> String {
        // добавляем 4 часа
        let addingTime = Double(4 * 60 * 60)
        let localizedDate = date.addingTimeInterval(addingTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm:ss"
        return formatter.string(from: localizedDate)
    }
    
    func getTimeOnly(date: Date) -> String {
        // добавляем 4 часа
        let addingTime = Double(4 * 60 * 60)
        let localizedDate = date.addingTimeInterval(addingTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: localizedDate)
    }
    
}
