////   /*
//
//  Project: WeatherApp
//  File: WeekWeatherView.swift
//  Created by: Robert Bikmurzin
//  Date: 13.10.2023
//
//  Status: in progress | Decorated
//
//  */

import UIKit
import SnapKit

class WeekWeatherView: UIView {
    // Variables:
    var viewModel: WeekWeatherViewModel?
    var tableView = UITableView()
    
    // Инициализация collectionView
    let collectionView: UICollectionView = {
        // Инициализация layout
        let layout = UICollectionViewFlowLayout()
        // Установка вертикального направления
        layout.scrollDirection = .vertical
        // Расстояние между строками collectionView
        layout.minimumLineSpacing = 16
        // Создаем объект Collection View с указанными frame и layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    } ()
    
    init(viewModel: WeekWeatherViewModel? = nil, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        backgroundColor = .mainBackgroundColor
        self.round()
        self.addWhiteShadow()
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        setupTableView()
        setupCollectionView()
    }
}


