//
//  Exception.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

struct Tags: JSONSerializable {
    
    var buildName: String!
    var buildVersion: String!
    var osVersion: String!
    var deviceModel: String!
    
    init() {
        self.buildVersion = ""
        self.buildName = ""
        self.osVersion = ""
        self.deviceModel = ""
    }
    init(dict: String){}
    init(dict: [String]){}
    
    init(buildName: String, buildVersion: String, osVersion: String, deviceModel: String ) {
        self.buildName = buildName
        self.buildVersion = buildVersion
        self.osVersion = osVersion
        self.deviceModel = deviceModel
    }
    
    init(dict: [String : Any]) {
        self.buildName = dict.tryConvert(forKey: "Build Name")
        self.buildVersion = dict.tryConvert(forKey: "Build version")
        self.osVersion = dict.tryConvert(forKey: "OS version")
        self.deviceModel = dict.tryConvert(forKey: "Device model")
    }
    
}

struct Exceptions: JSONSerializable {
    
    var exceptionID: MBOjectID = MBOjectID.init(objectID: "")
    var exceptionName: String!
    var level: String!
    var reason: String!
    var timestamp: String!
    var platform: String!
    var userInfo: String!
    var stackSymbols: [String]!
    var stackReturnAddress: [Double]!
    var tags: Tags!
    
    init() {}
    init(dict: String){}
    
    init(dict: [String]){}
    
    init(exceptionName: String, level:String, reason: String, timestamp: String, platform: String, userInfo: String, stackSymbols: [String], stackReturnAddress: [Double] ) {
        self.exceptionName = exceptionName
        self.level = level
        self.reason = reason
        self.timestamp = timestamp
        self.platform = platform
        self.userInfo = userInfo
        self.stackSymbols = stackSymbols
        self.stackReturnAddress = stackReturnAddress
        self.tags = Tags()
    }
    
    
    init( dict: [String:Any] ) {
        self.exceptionName = dict.tryConvert(forKey: "exeptionName")
        self.level = dict.tryConvert(forKey: "level")
        self.reason = dict.tryConvert(forKey: "reason")
        self.timestamp = dict.tryConvert(forKey: "timestamp")
        self.platform = dict.tryConvert(forKey: "platform")
        self.userInfo = dict.tryConvert(forKey: "userInfo")
        self.stackSymbols = dict.tryConvert(forKey: "stackSymbols")
        self.stackReturnAddress = dict.tryConvert(forKey: "stackReturnAddress")
        self.exceptionID = MBOjectID.init(objectID: dict.tryConvert(forKey: "_id"))
        self.tags = Tags(dict: dict.tryConvertObj(forKey: "tags"))
    }
}
