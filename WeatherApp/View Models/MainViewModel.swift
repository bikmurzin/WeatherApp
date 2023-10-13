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
    var currentWeatherDataSource: Observable<CurrentWeatherViewModel> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    var isCurrentWeatherLoading = false
    
    func getData(lat: String, lon: String) {
        getCurrentWeather(lat: lat, lon: lon)
    }
    
    private func getCurrentWeather(lat: String, lon: String) {
        if isCurrentWeatherLoading {
            return
        }
        isCurrentWeatherLoading = true
        isLoading.value = isCurrentWeatherLoading
        
        let urlString = "\(NetworkConstant.shared.currentWeatherAddress)?appid=\(NetworkConstant.shared.apiKey)&lat=\(lat)&lon=\(lon)&units=metric&lang=ru"
        APICaller.makeRequest(urlString: urlString) {[weak self] (result: Result<CurrentWeatherModel, NetworkError>) in
            self?.isCurrentWeatherLoading = false
            self?.isLoading.value = self?.isCurrentWeatherLoading
            
            switch result {
            case .success(let data):
                self?.currentWeatherDataSource.value = CurrentWeatherViewModel(currentWeather: data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
