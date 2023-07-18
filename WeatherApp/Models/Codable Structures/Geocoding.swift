//
//  Geocoding.swift
//  WeatherApp
//
//  Created by User on 06.07.2023.
//

import Foundation

struct LocalNames: Decodable {
    var ru: String
}

struct Geocoding: Decodable {
    var geocoding: [GeocodingElement]
    
    init(from decoder: Decoder) throws {
        //Парсим JSON с использованием unkeyed containers
        var container = try decoder.unkeyedContainer()
        var geocodingElements: [GeocodingElement] = []
        
        while !container.isAtEnd {
            geocodingElements.append(try container.decode(GeocodingElement.self))
        }
        geocoding = geocodingElements
    }
}

struct GeocodingElement: Decodable {
    var name: String
    var lat: Double
    var lon: Double
    var country: String
    var localNames: LocalNames
    
    enum CodingKeys: String, CodingKey {
        case name, lat, lon, country
        case localNames = "local_names"
    }
}


