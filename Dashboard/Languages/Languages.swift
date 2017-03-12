//
//  Languages.swift
//  Dashboard
//
//  Created by Timothy Barnard on 04/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

struct LanguageVersion: JSONSerializable {
    
    var objectID: MBOjectID?
    var languageID: String!
    var appVersion: String!
    var langVersion: String!
    var filePath:String!
    var languageName:String!
    var published:String!
    var date: String!
    
    init() {}
    
    init(languageID: String, appVersion:String, langVersion: String, filePath:String, languageName:String, published:String, date:String, objectID: String = "") {
        self.objectID = MBOjectID(objectID: objectID)
        self.languageID = languageID
        self.appVersion = appVersion
        self.langVersion = langVersion
        self.filePath = filePath
        self.languageName = languageName
        self.published = published
        self.date = date
    }
    
    init(dict:[String:Any]) {
        self.objectID = MBOjectID(objectID: dict.tryConvert(forKey: "_id"))
        self.languageID = dict.tryConvert(forKey: "langalanguageIDugeID")
        self.appVersion = dict.tryConvert(forKey: "appVersion")
        self.langVersion = dict.tryConvert(forKey: "langVersion")
        self.filePath = dict.tryConvert(forKey: "filePath")
        self.languageName = dict.tryConvert(forKey: "languageName")
        self.published = dict.tryConvert(forKey: "published", "0")
        self.date = dict.tryConvert(forKey: "date")
    }
    init(dict: [String]) {}
    init(dict: String) {
    }
}


struct Languages: JSONSerializable {
    
    var objectID: MBOjectID?
    var name:String!
    var available: Int!
    
    init() {
        self.objectID = MBOjectID(objectID: "")
        self.name = ""
        self.available = 0
    }
    
    init(name:String, available:Int ) {
        self.name = name
        self.available = available
    }
    
    init(dict:[String:Any]) {
        self.objectID = MBOjectID(objectID: dict.tryConvert(forKey: "_id"))
        self.name = dict.tryConvert(forKey: "name")
        self.available = dict.tryConvert(forKey: "available")
    }
    init(dict: [String]) {}
    init(dict: String) {
    }
}

struct TranslationKeys: JSONSerializable {
    
    var name:String!
    
    init() {
        self.name = ""
    }
    
    init(name:String ) {
        self.name = name
    }
    
    init(dict:[String:Any]) {
        self.name = dict.tryConvert(forKey: "name")
    }
    init(dict: [String]) {}
    init(dict: String) {}
}
