//
//  UIViewController.swift
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

import Foundation
import Mapbox
import Alamofire
import AlamofireObjectMapper

extension UIViewController {
    @objc func getListOfPoi(bounds: MGLCoordinateBounds) {
        RemoteApiFactory.instance.getPoiListBy(bounds: bounds)
            .validate()
            .responseObject { [weak self] (response: DataResponse<PoiWrapper>) in
                guard let _ = self else { return }
                switch response.result {
                case .success:
                    if let poiList = response.result.value {
                        NotificationCenter.default.post(
                            name: NSNotification.Name(rawValue: "PoisLoaded"),
                            object: nil,
                            userInfo: ["poiList": poiList])
                    }
                    break
                case .failure(let error):
                    NotificationCenter.default.post(
                        name: NSNotification.Name(rawValue: "ErrorGetPois"),
                        object: nil,
                        userInfo: ["error": error])
                    break
                }
        }
    }
    
    func removeBackButtonText() {
        self.parent?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
