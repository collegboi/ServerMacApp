//
//  NotificationSetting.swift
//  Dashboard
//
//  Created by Timothy Barnard on 12/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation


struct NotificationSetting: JSONSerializable {
    
    var name: String!
    var path: String!
    var keyID: String!
    var appID: String!
    var teamID: String!
    
    init(name:String, path:String,keyID: String, appID: String, teamID: String) {
        self.name = name
        self.path = path
        self.keyID = keyID
        self.appID = appID
        self.teamID = teamID
    }
    
    init() {}
    
    init(dict: String) {}
    
    init(dict: [String]) {}
    
    init(dict: [String : Any]) {
        self.name = dict.tryConvert(forKey: "name")
        self.path = dict.tryConvert(forKey: "path")
        self.keyID = dict.tryConvert(forKey: "keyID")
        self.appID = dict.tryConvert(forKey: "appID")
        self.teamID = dict.tryConvert(forKey: "teamID")
    }
}
