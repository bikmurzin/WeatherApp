//
//  CurrentWeatherCollectionView.swift
//  WeatherApp
//
//  Created by User on 12.07.2023.
//

import Foundation
import UIKit

class HourlyWeatherView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Временные исходные данные
    
    let degreeArray = ["+8°","+10°","+9°","+12°","+13°","+15°","+19°","+22°","+18°","+7°"]
    let hourArray = ["6:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00"]
    let iconArray = ["01d","10d","09d","10d","01d","11d","10d","01d","09d","11d"]
    
    
    
    // ID ячейки
    let cellId = "HourlyWeatherCell"
    
    let hourlyWeatherCollectionView: UICollectionView = {
        
        // Инициализация layout
        let layout = UICollectionViewFlowLayout()
        
        // Установка горизонтального направления
        layout.scrollDirection = .horizontal
        
        // Создание объекта Collection View с указанными frame и layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // Активация constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Цвет collectionView
        collectionView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        
        // Скрыть ползунок
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
        
    }()

    // Добавление CollectionView
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(hourlyWeatherCollectionView)
        
        hourlyWeatherCollectionView.dataSource = self
        hourlyWeatherCollectionView.delegate = self

        hourlyWeatherCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        hourlyWeatherCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        hourlyWeatherCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        hourlyWeatherCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        // Регистрация ячейки для collectionView
        hourlyWeatherCollectionView.register(HourlyWeatherCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Размеры ячеек в collectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = frame.height / 2
        let height = frame.height
        
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        degreeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = hourlyWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HourlyWeatherCell
        cell.degree.text = degreeArray[indexPath.row]
        cell.hour.text = hourArray[indexPath.row]
        cell.icon.image = UIImage(named: iconArray[indexPath.row])
        
        return cell
        
    }
    
}
