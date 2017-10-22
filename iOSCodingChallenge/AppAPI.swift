//
//  AppAPI.swift
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

import Foundation
import Alamofire
import Mapbox

protocol RemoteApi {
    func getPoiListBy(bounds: MGLCoordinateBounds) -> DataRequest
}

public class RemoteApiFactory {
    static var instance: RemoteApi {
        get {
            let urlString = Config.sharedInstance.get(key: "baseURL") as! String
            return API(apiUrl: urlString)
        }
    }
}

private class API: RemoteApi {
    private let manager = Manager.sharedInstance
    private let baseUrl: String
    
    init(apiUrl: String) {
        baseUrl = apiUrl
    }
    
    func getPoiListBy(bounds: MGLCoordinateBounds) -> DataRequest {
        
        let params: [String: Any] = [
            "p1Lat": bounds.sw.latitude,
            "p1Lon": bounds.sw.longitude,
            "p2Lat": bounds.ne.latitude,
            "p2Lon": bounds.ne.longitude,
            ]
        
        return manager.requestJSON(.get, url: "", body: nil, parameters: params, encoding: URLEncoding.default)
    }
}
