//
//  SightModel.swift
//  weatherApp
//
//  Created by Баир Надцалов on 06.11.2020.
//

import Foundation

struct SightModel: Codable {
    
    var name : String
    var relationTo : String
    var shortDescr : String?
    var fullDescr : String?
    var location : String?
    var image : String?
    
}
