//
//  SelfConfiguringCell.swift
//  WeatherApp
//
//  Created by Muhammad Osama Naeem on 3/28/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: ForecastTemperature)
}
