//
//  Coordinate.swift
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class Coordinate: NSObject, Mappable {
    var latitude = 0.0
    var longitude = 0.0
    
    override init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        latitude    <- map["latitude"]
        longitude   <- map["longitude"]
    }
}
