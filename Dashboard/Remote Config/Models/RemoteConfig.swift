//
//  RemoteConfig.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

struct RemoteConfig: JSONSerializable {
    
    var objectID: MBOjectID?
    var applicationID: String!
    var version: String!
    var path: String!
    var configVersion: String!
    
    init() {}
    
    init(dict: String){}
    
    init(applicationID:String, version: String, path: String, configVersion: String ) {
        self.objectID = MBOjectID(objectID: "")
        self.applicationID = applicationID
        self.version = version
        self.path = path
        self.configVersion = configVersion
    }
    
    init(dict: [String : Any]) {
        self.objectID = MBOjectID(objectID: dict.tryConvert(forKey: "_id"))
        self.applicationID = dict.tryConvert(forKey: "applicationID")
        self.version = dict.tryConvert(forKey: "version")
        self.path = dict.tryConvert(forKey: "path")
        self.configVersion = dict.tryConvert(forKey: "configVersion")
    }
    
    init(dict: [String]) {
        
    }
}
