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
    var currentWeatherDataSource: Observable<CurrentWeatherViewModel> = Observable(nil)
    var hourlyWeatherDataSource: Observable<HourlyWeatherViewModel> = Observable(nil)
    var weekWeatherDataSource: Observable<WeekWeatherViewModel> = Observable(nil)
    
    // Variables:
    var isLoading: Observable<Bool> = Observable(false)
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
            self.isCurrentWeatherLoading = false
            self.isLoading.value = (self.isCurrentWeatherLoading || self.isWeekWeatherLoading)
            
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
            self.isWeekWeatherLoading = false
            self.isLoading.value = (self.isCurrentWeatherLoading || self.isWeekWeatherLoading)
            
            switch result {
            case .success(let data):
                self.weekWeatherDataSource.value = WeekWeatherViewModel(weekWeather: data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
