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
    var langaugeID: String!
    var version: String!
    var filePath:String!
    var name:String!
    var published:String!
    var date: String!
    
    init() {}
    
    init(langaugeID: String, version:String, filePath:String, name:String, published:String, date:String, objectID: String = "") {
        self.objectID = MBOjectID(objectID: objectID)
        self.langaugeID = langaugeID
        self.version = version
        self.filePath = filePath
        self.name = name
        self.published = published
        self.date = date
    }
    
    init(dict:[String:Any]) {
        self.objectID = MBOjectID(objectID: dict.tryConvert(forKey: "_id"))
        self.langaugeID = dict.tryConvert(forKey: "langaugeID")
        self.version = dict.tryConvert(forKey: "version")
        self.filePath = dict.tryConvert(forKey: "filePath")
        self.name = dict.tryConvert(forKey: "name")
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
