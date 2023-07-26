//
//  CitySelectionViewController.swift
//  WeatherApp
//
//  Created by User on 20.07.2023.
//

import UIKit

class CitySelectionViewController: UIViewController {
    
//    let weatherView = UIView()
//    let currentCityLabel = UILabel()
    
    var cities: [City] = []
    
    let tableView = UITableView()
    
    let cellId = "cityCell"
    
    var filteredCities: [City] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    weak var delegate: (ViewControllerDelegateForCitySelection)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cities = City.cities()
        
        configureView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // MARK: Настройка параметров searchController
        // searchResultsUpdater - это свойство UISearchController'а, которое соответствует протоколу UISearchResultsUpdating. С этим протоколом UISearchResultsUpdating будет информировать класс о любых текстовых изменениях UISearchBar'а
        searchController.searchResultsUpdater = self
        // Если true, то ViewCintroller, содержащий искомую информацию, скрывается. Полезно, если используется другой ViewController для SearchResultsController
        searchController.obscuresBackgroundDuringPresentation = false
        // Заполняем placeholder
        searchController.searchBar.placeholder = "Введите название города"
        // Устанавливаем searchBar в navigationItem. Необходимо, т.к. InterfaceBuilder еще не совместим с UISearchController
        navigationItem.searchController = searchController
        // установив для параметра definesPresentationContext в контроллере представления значение true, вы гарантируете, что панель поиска не останется на экране, если пользователь перейдет к другому контроллеру представления, когда UISearchController активен
        definesPresentationContext = true
    }
    
    func filterContentForSearchText(_ searchText: String) {
          filteredCities = cities.filter { (city: City) -> Bool in
            return city.rus.lowercased().contains(searchText.lowercased())
          }
          tableView.reloadData()
    }

}

// MARK: Configuring View
extension CitySelectionViewController {
    func configureView() {
        view.backgroundColor = .white
        
        // Отображение погоды в текущем городе
        /*
        view.addSubview(weatherView)
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            weatherView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            weatherView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            weatherView.heightAnchor.constraint(equalToConstant: 100)
        ])
        weatherView.backgroundColor = .blue
        
        weatherView.addSubview(currentCityLabel)
        currentCityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentCityLabel.topAnchor.constraint(equalTo: weatherView.topAnchor,constant: 15),
            currentCityLabel.centerXAnchor.constraint(equalTo: weatherView.centerXAnchor)
        ])
        currentCityLabel.textColor = .white
        currentCityLabel.font = UIFont.boldSystemFont(ofSize: 20)
        */
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        tableView.backgroundColor = .white
    }
}

extension CitySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCities.count
        }
        
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(CityNameCell.self, forCellReuseIdentifier: cellId)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CityNameCell else { return UITableViewCell() }
        
        let city: City
        if isFiltering {
            city = filteredCities[indexPath.row]
        } else {
            city = cities[indexPath.row]
        }
        
        cell.cityNameLabel.text = city.rus
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let city: City
            if isFiltering {
                city = filteredCities[indexPath.row]
            } else {
                city = cities[indexPath.row]
            }
            
            delegate?.changeCity(newCity: city)
            
            navigationController?.popViewController(animated: true)
        }
    }
}

extension CitySelectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    
}
