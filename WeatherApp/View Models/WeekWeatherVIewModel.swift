////   /*
//
//  Project: WeatherApp
//  File: WeekWeatherVIewModel.swift
//  Created by: Robert Bikmurzin
//  Date: 14.10.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation

class WeekWeatherViewModel {
    var dataSource: [DailyWeatherCellViewModel] = []
    
    init(dataSource: [DailyWeatherCellViewModel]) {
        self.dataSource = dataSource
    }
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        dataSource.count
    }
    
    func getDataSource() -> [DailyWeatherCellViewModel] {
        return dataSource
    }
}
