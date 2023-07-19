//
//  ViewController.swift
//  WeatherApp
//
//  Created by User on 27.06.2023.
//

import UIKit

class ViewController: UIViewController{
    
    //Создаем подкласс SpinnerViewController
    let spinner = SpinnerViewController()
    
    let weatherData = WeatherData()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    var currentTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    var weatherDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let hourlyWeatherView: HourlyWeatherView = {
        let view = HourlyWeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let degreeAndIconStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    let fiveDaysWeatherView: FiveDaysWeatherView = {
        let view = FiveDaysWeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherData.delegate = self
        hourlyWeatherView.delegate = self
        fiveDaysWeatherView.delegate = self
        
        DispatchQueue.global(qos: .userInitiated).async(flags: .barrier) {
            self.weatherData.fetchGeocoding(city: "Samara")
        }
        view.backgroundColor = UIColor(red: 31/255, green: 174/255, blue: 233/255, alpha: 1)
        
    }
    
}


// MARK: Configure main screen
extension ViewController {
        
    func configureView() {
        
        view.addSubview(titleLabel)
        view.addSubview(currentTemperature)
        view.addSubview(weatherIcon)
        view.addSubview(weatherDescription)
        view.addSubview(hourlyWeatherView)
        view.addSubview(degreeAndIconStackView)
        view.addSubview(fiveDaysWeatherView)
        
        degreeAndIconStackView.addArrangedSubview(currentTemperature)
        degreeAndIconStackView.addArrangedSubview(weatherIcon)
        
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.width).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true
        
        degreeAndIconStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        degreeAndIconStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        degreeAndIconStackView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        degreeAndIconStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        weatherDescription.topAnchor.constraint(equalTo: degreeAndIconStackView.bottomAnchor, constant: 20).isActive = true
        weatherDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weatherDescription.widthAnchor.constraint(equalToConstant: weatherDescription.intrinsicContentSize.width).isActive = true
        weatherDescription.heightAnchor.constraint(equalToConstant: weatherDescription.intrinsicContentSize.height).isActive = true
        
        hourlyWeatherView.topAnchor.constraint(equalTo: weatherDescription.bottomAnchor, constant: 60).isActive = true
        hourlyWeatherView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        hourlyWeatherView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        hourlyWeatherView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        fiveDaysWeatherView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fiveDaysWeatherView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        fiveDaysWeatherView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        fiveDaysWeatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
    }
    
}


// MARK: Spinner
extension ViewController {
    //Метод для остановки Spinner
    private func stopIndicator() {
        self.spinner.willMove(toParent: nil)
        self.spinner.view.removeFromSuperview()
        self.spinner.removeFromParent()
    }
    
    //Метод для добавления Spinner в основное вью
    private func moveIndicator() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
}




