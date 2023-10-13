////   /*
//
//  Project: WeatherApp
//  File: CurrentWeatherView.swift
//  Created by: Robert Bikmurzin
//  Date: 12.10.2023
//
//  Status: in progress | Decorated
//
//  */

import UIKit
import SnapKit

class CurrentWeatherView: UIView {
    
    // Variables:
    var cityName: String = ""
    var currentTemp: String = "--"
    var weatherDescription: String = "--"
    var imageName: String = ""
    
    // Views:
    var cityLabel = UILabel()
    var currentTempLabel = UILabel()
    var weatherImageView = UIImageView()
    var weatherDescriptionLabel = UILabel()
    
    // View Model:
    var viewModel: CurrentWeatherViewModel?
    
    init(frame: CGRect, viewModel: CurrentWeatherViewModel? = nil) {
        self.viewModel = viewModel
        super.init(frame: frame)
        self.setupData()
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .mainBackgroundColor
        self.addWhiteShadow()
        
        let horizontalStackView = UIStackView(arrangedSubviews: [currentTempLabel, weatherImageView])
        horizontalStackView.axis = .horizontal
        let verticalStackView = UIStackView(arrangedSubviews: [cityLabel, horizontalStackView, weatherDescriptionLabel])
        verticalStackView.axis = .vertical
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        cityLabel.textAlignment = .center
        cityLabel.textColor = .white
        currentTempLabel.textColor = .white
        weatherDescriptionLabel.textColor = .white
        verticalStackView.alignment = .center
        verticalStackView.spacing = 20
    }
    
    private func setupData() {
        guard let viewModel = viewModel else  {
            return
        }
        cityName = viewModel.getCityName()
        currentTemp = viewModel.getCurrentTemp()
        weatherDescription = viewModel.getDescription()
        imageName = viewModel.getImageName()
        cityLabel.text = cityName
        currentTempLabel.text = currentTemp
        weatherDescriptionLabel.text = weatherDescription
        weatherImageView.image = UIImage(systemName: imageName)
    }
}
