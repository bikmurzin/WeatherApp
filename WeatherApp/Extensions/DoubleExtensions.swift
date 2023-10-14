////   /*
//
//  Project: WeatherApp
//  File: DoubleExtensions.swift
//  Created by: Robert Bikmurzin
//  Date: 14.10.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation

extension Double {
    
    /// Округляет полученный аргумент, преобразовывает его в строку и добавляет знак '+' или '-' в начало
    func prepareToShowDegrees() -> String {
        var stringTemp = String(Int(self))
        if self != 0 {
            if self > 0 {
                stringTemp = "+\(stringTemp)"
            } else {
                stringTemp = "-\(stringTemp)"
            }
        }
        return stringTemp
    }
}
