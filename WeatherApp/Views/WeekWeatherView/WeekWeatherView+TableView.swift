////   /*
//
//  Project: WeatherApp
//  File: WeekWeatherView+TableView.swift
//  Created by: Robert Bikmurzin
//  Date: 13.10.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation
import UIKit

extension WeekWeatherView: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        self.registerCells()
    }
    
    func registerCells() {
        tableView.register(DailyWeatherCell.self, forCellReuseIdentifier: DailyWeatherCell.identifier)
    }
    
    func reloadTableView(viewModel: WeekWeatherViewModel? = nil) {
        self.viewModel = viewModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections: \(viewModel?.numberOfSections())")
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRows: \(viewModel?.numberOfRows(in: section))")
        return viewModel?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherCell.identifier, for: indexPath) as? DailyWeatherCell else {
            return UITableViewCell()
        }
        guard let cellViewModel = self.viewModel?.dataSource[indexPath.row] else { return UITableViewCell()}
        cell.setupData(viewModel: cellViewModel)
        //        Убрать изменение отображения ячейки при ее выборе
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    
}
