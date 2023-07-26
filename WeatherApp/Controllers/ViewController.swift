//
//  ViewController.swift
//  WeatherApp
//
//  Created by User on 27.06.2023.
//

import UIKit

class ViewController: UIViewController{
    
    var currentCityName: String = "Москва"
    
    //Создаем подкласс SpinnerViewController
    let spinner = SpinnerViewController()
    
    let weatherData = WeatherData()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
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
        label.textAlignment = .center
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
        
        fetchWeatherForCity()
    }
    
    func fetchWeatherForCity() {
        if let cityName = APIData.directoryOfCities[currentCityName] {
            self.weatherData.fetchGeocoding(city: cityName)
        }
        titleLabel.text = currentCityName
    }
}


// MARK: Configuring view
extension ViewController {
        
    func configureView() {
        
        view.backgroundColor = UIColor(red: 31/255, green: 174/255, blue: 233/255, alpha: 1)
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -70),
            titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height)
        ])
        
        view.addSubview(currentTemperature)
        view.addSubview(weatherIcon)
                
        view.addSubview(hourlyWeatherView)
        view.addSubview(degreeAndIconStackView)
        view.addSubview(weatherDescription)
        NSLayoutConstraint.activate([
            weatherDescription.topAnchor.constraint(equalTo: degreeAndIconStackView.bottomAnchor, constant: 20),
            weatherDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            weatherDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            weatherDescription.heightAnchor.constraint(equalToConstant: weatherDescription.intrinsicContentSize.height)
        ])

        view.addSubview(fiveDaysWeatherView)
        
        degreeAndIconStackView.addArrangedSubview(currentTemperature)
        degreeAndIconStackView.addArrangedSubview(weatherIcon)
        
        degreeAndIconStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        degreeAndIconStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        degreeAndIconStackView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        degreeAndIconStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        hourlyWeatherView.topAnchor.constraint(equalTo: weatherDescription.bottomAnchor, constant: 60).isActive = true
        hourlyWeatherView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        hourlyWeatherView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        hourlyWeatherView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        fiveDaysWeatherView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fiveDaysWeatherView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        fiveDaysWeatherView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        fiveDaysWeatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        //rectangle.and.pencil.and.ellipsis
        let changeCityButton = createCustomButton(imageName: "rectangle.and.pencil.and.ellipsis", selector: #selector(changeCityButtonTapped))
        
        navigationItem.leftBarButtonItem = changeCityButton
    }
    
    func createCustomButton(imageName: String, selector: Selector) -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
    
    @objc private func changeCityButtonTapped() {
        print("changeCityButtonTapped")
        let citySelectionViewController = CitySelectionViewController()
        citySelectionViewController.delegate = self
        navigationController?.pushViewController(citySelectionViewController, animated: true)
        
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




