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
    // Выбрано значение 8, т.к. в JSON приходит погода с шагом в 3 часа (8 шагов - это сутки)
    let countElementsInHourlyWeather = 8
    
    var hourlyWeatherArray: [OneHourWeather] = []
    var fiveDaysWeatherArray: [OneDayWeather] = []
    
    // делегат ViewController для обновления данных
    weak var delegate: ViewControllerDelegateForModel?
    
    let apiData = APIData()
    
    private var currentWeather: CurrentWeather?
    
    private var fiveDaysWeather: FiveDaysWeather?
    
    private var geocoding: Geocoding?
    
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
                guard let weather = response.value else {
                    print("Не удалось распарсить")
                    return
                }
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
//                print(self.fiveDaysWeather)
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
    
    func getDataToDisplay(temp: Double?, feelsLike: Double?, icon: String?, pod: String?) -> (String, String, String, String) {
        var tempString = ""
        if let unwrTemp = temp {
            tempString = "\(Int(unwrTemp))°"
            if unwrTemp > 0 {
                tempString = "+\(tempString)"
            } else if unwrTemp < 0 {
                tempString = "-\(tempString)"
            }
        } else {
            tempString = "-"
        }
        
        var feelsLikeString = ""
        if let unwrFeelsLike = feelsLike {
            feelsLikeString = String(Int(unwrFeelsLike))
        } else {
            feelsLikeString = "-"
        }
        
        var iconString = ""
        if let unwrIcon = icon {
            iconString = unwrIcon
        } else {
            iconString = "questionmark.square"
        }
        
        var podString = ""
        if let unwrPod = pod {
            podString = unwrPod
        } else {
            podString = "-"
        }

        return (tempString, feelsLikeString, iconString, podString)
    }
    
    func fillingArrayWithHourlyWeather() {
        
        guard let list = fiveDaysWeather?.list else {return}
        
        var iterationCount = 0
        
        if list.count >= countElementsInHourlyWeather {
            iterationCount = countElementsInHourlyWeather
        } else {
            iterationCount = list.count
        }
        
        hourlyWeatherArray.removeAll()
        
        for i in 0..<iterationCount {
            let time = getTimeOnly(date: list[i].dt)
            
            let dataToDisplay = getDataToDisplay(temp: list[i].main.temp, feelsLike: list[i].main.feelsLike, icon: list[i].weather[0].icon, pod: list[i].sys.pod)
            let temp = dataToDisplay.0
            let feelsLike = dataToDisplay.1
            let icon = dataToDisplay.2
            let pod = dataToDisplay.3
            
            hourlyWeatherArray.append(OneHourWeather(time: time, temp: temp, feelsLike: feelsLike, icon: icon, pod: pod))
        }
    }
    
    func findMorningWeather(oneDayWeatherArray: [OneHourWeather]) -> OneHourWeather {
        for i in 0..<oneDayWeatherArray.count {
            if oneDayWeatherArray[i].pod == "d" {
                return oneDayWeatherArray[i]
            }
        }
        return oneDayWeatherArray[0]
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
            
            // сюда запишется имя изображения в момент максимальной температуры
            var icon = array[0].icon
            
            if array.count > 1 {
                for i in 1..<array.count {
                    if array[i].temp > maxTemp {
                        maxTemp = array[i].temp
                        icon = array[i].icon
                    }
                    if array[i].temp < minTemp {
                        minTemp = array[i].temp
                    }
                }
            }
            
            let stringDate = getDateAsString(date: date)
            
            var dayOfTheWeek = ""
            if let day = getDayOfTheWeek(date: date) {
                dayOfTheWeek = day
            }
            
            fiveDaysWeatherArray.append(OneDayWeather(date: stringDate, tempMin: minTemp, tempMax: maxTemp, icon: UIImage(named: icon), firstDayIndex: index, dayOfTheWeek: dayOfTheWeek))
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
            
            let dataToDisplay = getDataToDisplay(temp: list[i].main.temp, feelsLike: list[i].main.feelsLike, icon: list[i].weather[0].icon, pod: list[i].sys.pod)
            let temp = dataToDisplay.0
            let feelsLike = dataToDisplay.1
            let icon = dataToDisplay.2
            let pod = dataToDisplay.3
            
            oneDayWeatherArray.append(OneHourWeather(time: time, temp: temp, feelsLike: feelsLike, icon: icon, pod: pod))
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



