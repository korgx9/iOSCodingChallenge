//
//  AppAPI.swift
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

import Foundation
import Alamofire

protocol RemoteApi {
    func getPoiListBy(bounds: (Double, Double, Double,Double)) -> DataRequest
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
    
    func getPoiListBy(bounds: (Double, Double, Double,Double)) -> DataRequest {
        
        let params: [String: Any] = [
            "p1Lat": bounds.0,
            "p1Lon": bounds.1,
            "p2Lat": bounds.2,
            "p2Lon": bounds.3,
            ]
        
        return manager.requestJSON(.get, url: "", body: nil, parameters: params, encoding: URLEncoding.default)
    }
}
