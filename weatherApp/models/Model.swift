//
//  WeatherModel.swift
//  weatherApp
//
//  Created by Баир Надцалов on 03.11.2020.
//

import Foundation

struct Model: Codable {
    
    var timezone_offset: TimeInterval
    var hourly: [HourlyModel]
}
