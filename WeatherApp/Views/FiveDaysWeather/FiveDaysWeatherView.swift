//
//  FiveDaysCollectionView.swift
//  WeatherApp
//
//  Created by User on 12.07.2023.
//

import Foundation
import UIKit

class FiveDaysWeatherView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    
    
    // MARK: Исходные данные для заполнения
    var fiveDaysWeatherArray: [OneDayWeather] = []
    
    weak var delegate: ViewControllerDelegateForFiveDaysWeatherView?
    
    // Идентификатор ячейки
    let cellId = "FiveDaysWeatherCell"
    
    // Инициализация collectionView
    let fiveDaysCollectionView: UICollectionView = {
        
//         Инициализация layout
        let layout = UICollectionViewFlowLayout()
        
//         Установка горизонтального направления
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 1
        
//         Создаем объект Collection View с указанными frame и layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
//         активация constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .darkGray
        
        return collectionView
        
    } ()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(fiveDaysCollectionView)
        
        fiveDaysCollectionView.delegate = self
        fiveDaysCollectionView.dataSource = self
        
        fiveDaysCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        fiveDaysCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        fiveDaysCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        fiveDaysCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        fiveDaysCollectionView.register(FiveDaysWeatherCell.self, forCellWithReuseIdentifier: cellId)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Размеры ячеек в collectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = frame.width
        let height = frame.height / 5
        
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let delegate = delegate {
            fiveDaysWeatherArray = delegate.getFiveDaysWeather()
        }
        return fiveDaysWeatherArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = fiveDaysCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FiveDaysWeatherCell
        let day = fiveDaysWeatherArray[indexPath.row]
        
        cell.dayOfTheWeek.text = day.dayOfTheWeek
        cell.date.text = day.date
        cell.icon.image = day.icon
        cell.maxTemperature.text = day.tempMax
        cell.minTemperature.text = day.tempMin
        
        return cell
    }
    
    
}

