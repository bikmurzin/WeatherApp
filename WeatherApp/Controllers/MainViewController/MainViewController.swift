////   /*
//
//  Project: WeatherApp
//  File: MainViewController.swift
//  Created by: Robert Bikmurzin
//  Date: 12.10.2023
//
//  Status: in progress | Decorated
//
//  */

import UIKit

class MainViewController: UIViewController {
    
    // View Models:
    var viewModel = MainViewModel()
    
    // Views:
    var currentWeatherView = UIView()
    var weekWeatherView = WeekWeatherView(frame: CGRect.zero)
    var activityIndicator = UIActivityIndicatorView()
    
    // Variables:
//    var currentWeatherViewModel: CurrentWeatherViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getData(lat: "55.751244", lon: "37.618423")
    }
    
    func configView() {
        view.backgroundColor = .mainBackgroundColor
        setupCurrentWeatherView()
        setupWeekWeatherView()
    }
    
    func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.currentWeatherDataSource.bind { [weak self] currentWeather in
            guard let self = self, let currentWeather = currentWeather else {
                return
            }
//            self.currentWeatherViewModel = currentWeather
            setupCurrentWeatherView()
            
        }
        
        viewModel.weekWeatherDataSource.bind { [weak self] weekWeather in
            guard let self = self, let weekWeather = weekWeather else {
                return
            }
//            setupWeekWeatherView()
            updateWeekWeatherView()
        }
    }
}
