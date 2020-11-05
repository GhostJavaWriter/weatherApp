//
//  HourlyModel.swift
//  weatherApp
//
//  Created by Баир Надцалов on 03.11.2020.
//

import Foundation

struct HourlyModel: Codable {
    
    var dt: TimeInterval
    var temp: Float
    var weather: [WeatherModel]
}
