////   /*
//
//  Project: WeatherApp
//  File: DailyWeatherCell.swift
//  Created by: Robert Bikmurzin
//  Date: 13.10.2023
//
//  Status: in progress | Decorated
//
//  */

import UIKit
import SnapKit

class DailyWeatherCell: UITableViewCell {
    
    public static var identifier: String {
        get {
            return "DailyWeatherCell"
        }
    }
    
//    public static func register() -> UINib {
//        UINib(nibName: "DailyWeatherCell", bundle: nil)
//    }

    // Views:
    var maxDayTemp = UILabel()
    var minDayTemp = UILabel()
    var dateLabel = UILabel()
    var dayOfWeekLabel = UILabel()
    var weatherImage = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.mainBackgroundColor
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(viewModel: DailyWeatherCellViewModel) {
        print("viewModel.date: \(viewModel.date)")
        self.maxDayTemp.text = viewModel.maxDailyTemp
        self.minDayTemp.text = viewModel.minDailyTemp
        self.dateLabel.text = viewModel.date
        self.dayOfWeekLabel.text = viewModel.dayOfWeek
        self.weatherImage.image = UIImage(named: viewModel.imageName)
        self.weatherImage.tintColor = .white
    }
    
    func setupView() {
        addSubviews([ maxDayTemp, minDayTemp, dateLabel, dayOfWeekLabel, weatherImage ])
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalTo(snp.centerY).inset(8)
        }
        dayOfWeekLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(snp.centerY).inset(8)
        }
        minDayTemp.snp.makeConstraints { make in
            make.leading.equalTo(snp.trailing).multipliedBy(0.9)
            make.centerY.equalTo(snp.centerY)
        }
        maxDayTemp.snp.makeConstraints { make in
            make.leading.equalTo(snp.trailing).multipliedBy(0.75)
            make.centerY.equalTo(snp.centerY)
        }
        weatherImage.snp.makeConstraints { make in
            make.leading.equalTo(snp.trailing).multipliedBy(0.6)
            make.centerY.equalTo(snp.centerY)
            make.height.width.equalTo(35)
        }
    }

}
