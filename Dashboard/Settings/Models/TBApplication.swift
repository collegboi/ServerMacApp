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
    case Other = "Other"
}

struct TBApplication: JSONSerializable {
    
    var name: String!
    var databaseName: String!
    var apID: String!
    var itunesAppID: String!
    var itunesAppIconURL: String!
    var appKey: String!
    var appPrice: String!
    var appRating: String!
    var appDescription: String!
    var appPrimaryGenre: String!
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
    
    init(name:String, databaseName: String, apID: String, appKey:String, appType: String,
         itunesAppID: String, itunesAppIconURL: String, appPrice: String, appRating: String, appDescription: String, appPrimaryGenre: String ) {
        self.objectID = MBOjectID(objectID: "")
        self.name = name
        self.databaseName = databaseName
        self.apID = apID
        self.appKey = appKey
        self.itunesAppID = itunesAppID
        self.itunesAppIconURL = itunesAppIconURL
        self.appPrice = appPrice
        self.appRating = appRating
        self.appDescription = appDescription
        self.appPrimaryGenre = appPrimaryGenre
        
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
        self.itunesAppID = dict.tryConvert(forKey: "itunesAppID")
        self.itunesAppIconURL = dict.tryConvert(forKey: "itunesAppIconURL")
        self.appPrice = dict.tryConvert(forKey: "appPrice")
        self.appRating = dict.tryConvert(forKey: "appRating")
        self.appDescription = dict.tryConvert(forKey: "appDescription")
        self.appPrimaryGenre = dict.tryConvert(forKey: "appPrimaryGenre")
        
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
    var imageURLs = [String]()
    
    init() {}
    
    init(dict: String){}
    
    init(applicationID:String, version: String, date: String, notes: String, imageURLs: [String] ) {
        self.objectID = MBOjectID(objectID: "")
        self.applicationID = applicationID
        self.version = version
        self.date = date
        self.notes = notes
        self.imageURLs = imageURLs
    }
    
    init(dict: [String : Any]) {
        self.objectID = MBOjectID(objectID: dict.tryConvert(forKey: "_id"))
        self.applicationID = dict.tryConvert(forKey: "applicationID")
        self.version = dict.tryConvert(forKey: "version")
        self.date = dict.tryConvert(forKey: "date")
        self.notes = dict.tryConvert(forKey: "notes")
        self.imageURLs = dict.tryConvert(forKey: "imageURLs")
    }
    
    init(dict: [String]) {
        
    }
}
