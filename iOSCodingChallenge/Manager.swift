//
//  Manager.swift
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

import Foundation
import Alamofire

class Manager: SessionManager {
    
    class var sharedInstance: Manager {
        struct Static {
            private static let serverTrustPolicies: [String: ServerTrustPolicy] = [
                Config.sharedInstance.get(key: "baseURL") as! String: .pinCertificates(
                    certificates: ServerTrustPolicy.certificates(),
                    validateCertificateChain: true,
                    validateHost: true
                )]
            static let instance: Manager = Manager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        }
        
        return Static.instance
    }
    
    public func requestJSON(_ method: HTTPMethod, url:String, body:NSData? = nil, parameters:[String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
        let url = Config.sharedInstance.get(key: "baseURL") as! String + "/PoiService/poi/v1/" + url
        
        return request(url, method: method, parameters: parameters, encoding: encoding)
    }
}
