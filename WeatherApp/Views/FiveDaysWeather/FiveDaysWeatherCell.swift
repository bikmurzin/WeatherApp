//
//  FiveDaysCell.swift
//  WeatherApp
//
//  Created by User on 13.07.2023.
//

import UIKit

class FiveDaysWeatherCell: UICollectionViewCell {
    
    // MARK: Элементы ячейки
    
    // День недели
    let dayOfTheWeek: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Arial", size: 18)
        return label
    }()
    
    // Дата
    let date: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial", size: 14)
        label.textColor = .darkGray
        return label
    }()
    
    // Максимальная температура
    let maxTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    //Минимальная температура
    let minTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // Иконка
    let icon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        addSubview(dayOfTheWeek)
        addSubview(date)
        addSubview(maxTemperature)
        addSubview(minTemperature)
        addSubview(icon)
        
        let height: CGFloat = 20
        
        date.bottomAnchor.constraint(equalTo: topAnchor, constant: frame.height / 3).isActive = true
        date.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        date.heightAnchor.constraint(equalToConstant: height).isActive = true
        date.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        dayOfTheWeek.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -frame.height / 3).isActive = true
        dayOfTheWeek.leftAnchor.constraint(equalTo: date.leftAnchor).isActive = true
        dayOfTheWeek.heightAnchor.constraint(equalToConstant: height).isActive = true
        dayOfTheWeek.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        minTemperature.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        minTemperature.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        minTemperature.widthAnchor.constraint(equalToConstant: 50).isActive = true
        minTemperature.heightAnchor.constraint(equalToConstant: height).isActive = true

        maxTemperature.rightAnchor.constraint(equalTo: minTemperature.leftAnchor, constant: -10).isActive = true
        maxTemperature.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        maxTemperature.widthAnchor.constraint(equalToConstant: 50).isActive = true
        maxTemperature.heightAnchor.constraint(equalToConstant: height).isActive = true

        icon.rightAnchor.constraint(equalTo: maxTemperature.leftAnchor, constant: -10).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        icon.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
