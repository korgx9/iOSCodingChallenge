//
//  PoiWrapper.swift
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

import Foundation
import ObjectMapper

class PoiWrapper: Mappable {
    var pois: [Poi] = [Poi]()
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        pois <- map["poiList"]
    }
}
