//
//  TBApplication.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

enum AppType: String {
    case iOS = "iOS"
    case Android = "Android"
}

struct TBApplication: JSONSerializable {
    
    var name: String!
    var databaseName: String!
    var apID: String!
    var appKey: String!
    var appType: AppType!
    var objectID: MBOjectID?
    
    mutating func setApptype(_ appType: String) {
        switch appType {
        case "iOS":
            self.appType = .iOS
        default:
            self.appType = .Android
        }
    }
    
    init() {}
    
    init(dict: String){}
    
    init(name:String, databaseName: String, apID: String, appKey:String, appType: String ) {
        self.objectID = MBOjectID(objectID: "")
        self.name = name
        self.databaseName = databaseName
        self.apID = apID
        self.appKey = appKey
        
        switch appType {
        case "iOS":
            self.appType = .iOS
        default:
            self.appType = .Android
        }
    }
    
    init(dict: [String : Any]) {
        self.databaseName = dict.tryConvert(forKey: "databaseName")
        self.apID = dict.tryConvert(forKey: "apID")
        self.name = dict.tryConvert(forKey: "name")
        self.appKey = dict.tryConvert(forKey: "appKey")
        self.objectID = MBOjectID(objectID: dict.tryConvert(forKey: "_id"))
        let appType: String  = dict.tryConvert(forKey: "appType")
        
        switch appType {
        case "iOS":
            self.appType = .iOS
        default:
            self.appType = .Android
        }
    }
    
    init(dict: [String]) {
        
    }
}

struct TBAppVersion: JSONSerializable {
    
    var objectID: MBOjectID?
    var applicationID: String!
    var version: String!
    var date: String!
    var notes: String!
    
    init() {}
    
    init(dict: String){}
    
    init(applicationID:String, version: String, date: String, notes: String ) {
        self.objectID = MBOjectID(objectID: "")
        self.applicationID = applicationID
        self.version = version
        self.date = date
        self.notes = notes
    }
    
    init(dict: [String : Any]) {
        self.objectID = MBOjectID(objectID: dict.tryConvert(forKey: "_id"))
        self.applicationID = dict.tryConvert(forKey: "applicationID")
        self.version = dict.tryConvert(forKey: "version")
        self.date = dict.tryConvert(forKey: "date")
        self.notes = dict.tryConvert(forKey: "notes")
    }
    
    init(dict: [String]) {
        
    }
}
