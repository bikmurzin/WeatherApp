//
//  HourlyWeatherCell.swift
//  WeatherApp
//
//  Created by User on 13.07.2023.
//

import UIKit

class HourlyWeatherCell: UICollectionViewCell {
    
    // Время
    let hour: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    // Температура
    let degree: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    // Иконка погоды
    let icon = UIImageView()
    
    // UIStackView, в который будут помещены остальные элементы
    let stack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        stack.addArrangedSubview(hour)
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(degree)
                
        stack.alignment = .center
        stack.axis = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
