//
//  City.swift
//  WeatherApp
//
//  Created by Robert Bikmurzin on 26.07.2023.
//

import Foundation

struct City: Decodable {
    let rus: String
    let eng: String
}
    
extension City {
    static func cities() -> [City] {
        guard
            let url = Bundle.main.url(forResource: "cities", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([City].self, from: data)
        } catch {
            return []
        }
    }
}
