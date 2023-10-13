////   /*
//
//  Project: WeatherApp
//  File: MainViewController+TableView.swift
//  Created by: Robert Bikmurzin
//  Date: 12.10.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation

extension MainViewController {
    func setupCurrentWeatherView() {
        let zeroFrame = CGRect.zero
        currentWeatherView = CurrentWeatherView(frame: zeroFrame, viewModel: viewModel.currentWeatherDataSource.value)
        view.addSubview(currentWeatherView)
        currentWeatherView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.25)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
