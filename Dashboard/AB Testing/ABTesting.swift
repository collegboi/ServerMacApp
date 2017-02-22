//
//  ABTesting.swift
//  Dashboard
//
//  Created by Timothy Barnard on 12/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

struct ABTesting: JSONSerializable {
    
    var name: String!
    var version: String!
    var versionA: String!
    var versionB: String!
    var startDateTime: String!
    var endDateTime: String!
    
    
    init(name: String, version: String, versionA: String, versionB: String, startDateTime: String, endDateTime: String) {
        self.name = name
        self.version = version
        self.versionA = versionA
        self.versionB = versionB
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
    }
    
    init(dict: [String : Any]) {
        self.name = dict.tryConvert(forKey: "name")
        self.version = dict.tryConvert(forKey: "version")
        self.versionA = dict.tryConvert(forKey: "versionA")
        self.versionB = dict.tryConvert(forKey: "versionB")
        self.startDateTime = dict.tryConvert(forKey: "startDateTime")
        self.endDateTime = dict.tryConvert(forKey: "endDateTime")
    }
    
    init() {}
    init(dict: [String]) {}
    
    init(dict: String) {}
    
}
