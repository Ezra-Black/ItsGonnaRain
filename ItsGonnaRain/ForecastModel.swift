//
//  ForecastModel.swift
//  ItsGonnaRain
//
//  Created by Ezra Black on 6/23/21.
//

import Foundation

struct WeatherInfo {
    let temp            : Float
    let min_temp        : Float
    let max_temp        : Float
    let description     : String
    let icon            : String
    let time            : String
}

struct ForecastTemperature {
    let weekDay         : String?
    let hourlyForecast  : [WeatherInfo]?
}
