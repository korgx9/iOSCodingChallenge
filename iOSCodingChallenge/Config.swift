//
//  Config.swift
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

import Foundation

struct Config {
    
    private var dictionary: [String: Any]
    static let sharedInstance = Config()
    
    init() {
        if let path = Bundle.main.path(forResource: "config", ofType: "plist") {
            dictionary = NSMutableDictionary(contentsOfFile: path)! as! [String : Any]
        }
        else {
            debugPrint("Cannot find `config.plist` file")
            exit(1)
        }
    }
    
    func get(key: String, defaultValue: Any) -> Any {
        if let options = dictionary[key] {
            return options
        }
        return defaultValue
    }
    
    func get(key: String) -> Any {
        return self.get(key: key, defaultValue: "")
    }
}
