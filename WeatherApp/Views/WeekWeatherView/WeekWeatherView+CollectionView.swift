////   /*
//
//  Project: WeatherApp
//  File: WeekWeatherView+CollectionView.swift
//  Created by: Robert Bikmurzin
//  Date: 14.10.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation
import UIKit

extension WeekWeatherView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}
