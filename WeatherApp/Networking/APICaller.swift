////   /*
//
//  Project: WeatherApp
//  File: APICaller.swift
//  Created by: Robert Bikmurzin
//  Date: 11.10.2023
//
//  Status: in progress | Decorated
//
//  */

import Foundation

enum NetworkError: Error {
    case urlError
    case canNotParseData
}

class APICaller {
    static func makeRequest<T: Decodable>(urlString: String,
        completionHandler: @escaping (_ result: Result<T, NetworkError>) -> Void
    ) {
        guard let url =  URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
            print(dataResponse)
            
            if error == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(T.self, from: data) {
                completionHandler(.success(resultData))
            } else {
                completionHandler(.failure(.canNotParseData))
            }
        }.resume()
    }
    
    static func makeRequestV2(urlString: String,
        completionHandler: @escaping (_ result: Result<CurrentWeatherModel, NetworkError>) -> Void
    ) {
        guard let url =  URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, error in
            print(dataResponse)
            
            if error == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(CurrentWeatherModel.self, from: data) {
                completionHandler(.success(resultData))
            } else {
                completionHandler(.failure(.canNotParseData))
            }
        }.resume()
    }
}
