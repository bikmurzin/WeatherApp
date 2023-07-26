//
//  CityNameCell.swift
//  WeatherApp
//
//  Created by Robert Bikmurzin on 26.07.2023.
//

import UIKit

class CityNameCell: UITableViewCell {
    
    let cityNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        addSubview(cityNameLabel)
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        NSLayoutConstraint.activate([
            cityNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            cityNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        cityNameLabel.textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
