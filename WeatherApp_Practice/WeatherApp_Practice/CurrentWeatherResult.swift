//
//  CurrentWeatherResult.swift
//  WeatherApp_Practice
//
//  Created by t2023-m0033 on 12/6/24.
//

import Foundation
// MARK: CurrentWeatherResult
struct CurrentWeatherResult: Codable {
    let weather: [Weather]
    let main: WeatherMain
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}
// MARK: - WeatherMain
struct WeatherMain: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
          case temp
          case tempMin = "temp_min"
          case tempMax = "temp_max"
      }
}
