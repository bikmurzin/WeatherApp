////   /*
//
//  Project: WeatherApp
//  File: MainViewModel.swift
//  Created by: Robert Bikmurzin
//  Date: 13.10.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation

class MainViewModel {
    // Data Sources:
    private (set) var currentWeatherDataSource: Observable<CurrentWeatherViewModel> = Observable(nil)
    private (set) var weekWeatherDataSource: Observable<WeekWeatherViewModel> = Observable(nil)
    private (set) var weekForecastDataSource: [OneHourForecast] = []
    
    // Variables:
    private (set) var isLoading: Observable<Bool> = Observable(false)
    var isCurrentWeatherLoading = false
    var isWeekWeatherLoading = false
    
    func getData(lat: String, lon: String) {
        getCurrentWeather(lat: lat, lon: lon)
        getWeekWeather(lat: lat, lon: lon)
    }
    
    private func getCurrentWeather(lat: String, lon: String) {
        if isCurrentWeatherLoading {
            return
        }
        isCurrentWeatherLoading = true
        isLoading.value = isCurrentWeatherLoading || isWeekWeatherLoading
        
        let urlString = "\(NetworkConstant.shared.currentWeatherAddress)?appid=\(NetworkConstant.shared.apiKey)&lat=\(lat)&lon=\(lon)&units=metric&lang=ru"
        APICaller.makeRequest(urlString: urlString) {[weak self] (result: Result<CurrentWeatherModel, NetworkError>) in
            guard let self = self else { return }
            isCurrentWeatherLoading = false
            isLoading.value = isCurrentWeatherLoading || isWeekWeatherLoading
            switch result {
            case .success(let data):
                self.currentWeatherDataSource.value = CurrentWeatherViewModel(currentWeather: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getWeekWeather(lat: String, lon: String) {
        if isWeekWeatherLoading {
            return
        }
        isWeekWeatherLoading = true
        isLoading.value = isCurrentWeatherLoading || isWeekWeatherLoading
        
        let urlString = "\(NetworkConstant.shared.weekWeatherAddress)?appid=\(NetworkConstant.shared.apiKey)&lat=\(lat)&lon=\(lon)&units=metric&lang=ru"
        APICaller.makeRequest(urlString: urlString) {[weak self] (result: Result<WeekWeatherModel, NetworkError>) in
            guard let self = self else { return }
            isWeekWeatherLoading = false
            isLoading.value = isCurrentWeatherLoading || isWeekWeatherLoading
            switch result {
            case .success(let data):
                self.weekForecastDataSource = data.list
                mapCellData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func mapCellData() {
        var currentDate: Date? = nil
        var allDates: [Date] = []
        for oneHourForecast in weekForecastDataSource {
            if let unwrCurrentDate = currentDate {
                if !Calendar.current.isDate(unwrCurrentDate, inSameDayAs: oneHourForecast.dt) {
                    currentDate = oneHourForecast.dt
                    allDates.append(unwrCurrentDate)
                }
            } else {
                currentDate = oneHourForecast.dt
                allDates.append(oneHourForecast.dt)
            }
        }
        var tmpWeekWeatherCellDataSource: [DailyWeatherCellViewModel] = []
//        print("allDates.count: \(allDates.count)")
//        print("weekForecastDataSource.count: \(weekForecastDataSource.count)")
        for date in allDates {
            let tmpOneHourForecastArray = weekForecastDataSource.filter({ Calendar.current.isDate($0.dt, inSameDayAs: date) })
//            print("tmpOneHourForecastArray.count: \(tmpOneHourForecastArray.count)")
            tmpWeekWeatherCellDataSource.append(DailyWeatherCellViewModel(for: tmpOneHourForecastArray))
            
        }
        
        weekWeatherDataSource.value = WeekWeatherViewModel(dataSource: tmpWeekWeatherCellDataSource)
        print("tmpWeekWeatherCellDataSource[0].dayOfWeek: \(tmpWeekWeatherCellDataSource[0].dayOfWeek)")
        print("weekWeatherDataSource.value?.dataSource[0].dayOfWeek: \(weekWeatherDataSource.value?.dataSource[0].dayOfWeek)")
//        print("weekWeatherDataSource.value?.dataSource: \(weekWeatherDataSource.value?.dataSource)")
    }
}
