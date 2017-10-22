//
//  Poi.swift
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class Poi: NSObject, Mappable {
    var id = 0
    var coordinate: Coordinate = Coordinate()
    var heading = 0.0
    var state = ""
    var type = ""
    
    override init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id          <- map["id"]
        coordinate  <- map["coordinate"]
        heading     <- map["heading"]
        state       <- map["state"]
        type        <- map["type"]
    }
    
    func getCoordinates() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude)
    }
}
