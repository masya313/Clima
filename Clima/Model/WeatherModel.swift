//
//  WeatherModel.swift
//  Clima
//
//  Created by Anastasia Krylova on 23.06.2022.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureValue: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 800:
            return "sun.max.fill"
        case 801...804:
            return "cloud.fill"
        case 200...232:
            return "cloud.bolt"
        default:
            return "cloud"
            
        }
    }
    
}
