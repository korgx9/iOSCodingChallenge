//
//  ViewController.swift
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //(53.694865, 9.757589 & 53.394655, 10.099891).
        
        let hamburgBounds = (53.694865, 9.757589, 53.394655, 10.099891)
        let req = RemoteApiFactory.instance.getPoiListBy(bounds: hamburgBounds)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print(response.result.value ?? "No Value")
                    break
                case .failure(let error):
                    print("Error: " + error.localizedDescription)
                    break
                }
        }
        
        debugPrint(req)
    }
}

