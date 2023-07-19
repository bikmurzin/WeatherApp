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
    
    // MARK: dictionary for rating of icons
    var iconRatingDictionary = ["01d": 1,
                                "01n": 1,
                                "02d": 2,
                                "02n": 2,
                                "03d": 3,
                                "03n": 3,
                                "04d": 4,
                                "04n": 4,
                                "09d": 9,
                                "09n": 9,
                                "10d": 10,
                                "10n": 10,
                                "11d": 11,
                                "11n": 11,
                                "13d": 13,
                                "13n": 13,
                                "50d": 50,
                                "50n": 50]
    
    var iconFromRating =        [1: "01d",
                                 2: "02d",
                                 3: "03d",
                                 4: "04d",
                                 9: "09d",
                                 10: "10d",
                                 11: "11d",
                                 13: "13d",
                                 50: "50d"]
    
    // Количество элементов, отображаемых в почасовой погоде
    // Выбрано значение 8, т.к. в JSON приходит погода с шагом в 3 часа (8 - это сутки)
    let countElementsInHourlyWeather = 8
    
    var hourlyWeatherArray: [OneHourWeather] = []
    var fiveDaysWeatherArray: [OneDayWeather] = []
    
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
                self.fillingArrayWithFiveDaysWeather()
                
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
                
                let temp = Int(list[i].main.temp)
                var tempString = "\(temp)°"
                if temp > 0 {
                    tempString = "+\(tempString)"
                } else if temp < 0 {
                    tempString = "-\(tempString)"
                }
                
                let feelsLike = String(Int(list[i].main.feelsLike))
                let icon = list[i].weather[0].icon
                hourlyWeatherArray.append(OneHourWeather(time: time, temp: tempString, feelsLike: feelsLike, icon: icon))
                
            }
    }
    
    func fillingArrayWithFiveDaysWeather() {
        
        guard let list = fiveDaysWeather?.list else {return}
        
        let fourHoursInterval = Double(4 * 60 * 60)
        
        let currentDate = getDateWithoutYearAndHour(date: Date().addingTimeInterval(fourHoursInterval))
        
        var index = 0
        
        index = getNextDayIndex(currentDate: currentDate, index: index)
        
        fiveDaysWeatherArray.removeAll()
        
        // Значение -1 в переменной index означает достижение конца массива
        while index != -1 {
            let array = getOneDayArray(startIndex: index)
            let date = getDateWithoutYearAndHour(date: list[index].dt)
            
            //iconRatingDictionary
            
            var minTemp = array[0].temp
            var maxTemp = array[0].temp
            
            
            // сюда запишется рейтинг изображения
            var ratingIcon = 0
            if let rating = iconRatingDictionary[array[0].icon] {
                ratingIcon = rating
            }
            // сюда запишется имя изображения с худшими погодными условиями за день
            var worstWeatherIcon = iconFromRating[ratingIcon]!
            
            if array.count > 1 {
                for i in 1..<array.count {
                    if array[i].temp > maxTemp {
                        maxTemp = array[i].temp
                    }
                    if array[i].temp < minTemp {
                        minTemp = array[i].temp
                    }
                    var comparingRatingIcon = ratingIcon
                    if let rating = iconRatingDictionary[array[i].icon] {
                        comparingRatingIcon = rating
                    }
                    if comparingRatingIcon > ratingIcon {
                        ratingIcon = comparingRatingIcon
                        worstWeatherIcon = iconFromRating[ratingIcon]!
                    }
                }
            }
            
            let stringDate = getDateAsString(date: date)
            
            var dayOfTheWeek = ""
            if let day = getDayOfTheWeek(date: date) {
                dayOfTheWeek = day
            }
            
            fiveDaysWeatherArray.append(OneDayWeather(date: stringDate, tempMin: minTemp, tempMax: maxTemp, icon: UIImage(named: worstWeatherIcon), firstDayIndex: index, dayOfTheWeek: dayOfTheWeek))
            index = getNextDayIndex(currentDate: date, index: index)
        }   // конец while
    }
    
    func getNextDayIndex(currentDate: Date, index: Int) -> Int {
        guard let list = fiveDaysWeather?.list else {return -1}
        
        var indexToReturn = index
        
        if indexToReturn == list.count - 1 {
            return -1
        } else {
            indexToReturn += 1
        }
        
        let processedCurrentDate = getDateWithoutYearAndHour(date: currentDate)
        var comparingDate = getDateWithoutYearAndHour(date: list[index].dt)
        
        var resultOfComparing = processedCurrentDate.compare(comparingDate).rawValue
        
        // Получение индекса следующего дня после текущего
        while resultOfComparing != -1 && indexToReturn < list.count {
            comparingDate = getDateWithoutYearAndHour(date: list[indexToReturn].dt)
            indexToReturn += 1
            resultOfComparing = processedCurrentDate.compare(comparingDate).rawValue
        }
        
        if resultOfComparing > -1 {
            return -1
        } else {
            return indexToReturn
        }
    }
    
    func getOneDayArray(startIndex: Int) -> [OneHourWeather] {
        guard let list = fiveDaysWeather?.list else {return []}
        let currentDate = getDateWithoutYearAndHour(date: list[startIndex].dt)
        var finishIndex = getNextDayIndex(currentDate: currentDate, index: startIndex)
        if finishIndex == -1 {
            finishIndex = list.count
        }
        
        var oneDayWeatherArray: [OneHourWeather] = []
        
        for i in startIndex..<finishIndex {
            let time = getTimeOnly(date: list[i].dt)
            // удаляем дробную часть и переводим в String
            
            let temp = Int(list[i].main.temp)
            var tempString = "\(temp)°"
            if temp > 0 {
                tempString = "+\(tempString)"
            } else if temp < 0 {
                tempString = "-\(tempString)"
            }
            
            let feelsLike = String(Int(list[i].main.feelsLike))
            let icon = list[i].weather[0].icon
            
            
            oneDayWeatherArray.append(OneHourWeather(time: time, temp: tempString, feelsLike: feelsLike, icon: icon))
        }
        
        return oneDayWeatherArray
    }
    
}

// MARK: Work with date
extension WeatherData {
    
    func getDateAndTime(date: Date) -> String {
        // добавляем 4 часа
//        let addingTime = Double(4 * 60 * 60)
        let addingTime = Double(0)
        let localizedDate = date.addingTimeInterval(addingTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm:ss"
        return formatter.string(from: localizedDate)
    }
    
    func getTimeOnly(date: Date) -> String {
        // добавляем 4 часа
//        let addingTime = Double(4 * 60 * 60)
        let addingTime = Double(0)
        let localizedDate = date.addingTimeInterval(addingTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: localizedDate)
    }
    
    func getDateWithoutYearAndHour(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        let string = formatter.string(from: date)
        let newDate = formatter.date(from: string)
        return newDate!
    }
    
    func getDateAsString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        
        let string = formatter.string(from: date)
        return string
    }
    
    func getDayOfTheWeek(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
        
    }
    
}



