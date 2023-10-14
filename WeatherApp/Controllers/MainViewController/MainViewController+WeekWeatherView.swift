////   /*
//
//  Project: WeatherApp
//  File: MainViewController+WeekWeatherView.swift
//  Created by: Robert Bikmurzin
//  Date: 14.10.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation

extension MainViewController {
    func setupWeekWeatherView() {
        let zeroFrame = CGRect.zero
        weekWeatherView = WeekWeatherView(viewModel: viewModel.weekWeatherDataSource.value, frame: zeroFrame)
        view.addSubview(weekWeatherView)
        weekWeatherView.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherView.snp.bottom).inset(-20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func updateWeekWeatherView(){
        weekWeatherView.reloadTableView(viewModel: viewModel.weekWeatherDataSource.value)
    }
    
}
