//
//  Languages.swift
//  Dashboard
//
//  Created by Timothy Barnard on 04/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

struct Languages: JSONSerializable {
    
    var version: String!
    var filePath:String!
    var name:String!
    var published:String!
    var date: String!
    
    init() {
        self.version = ""
        self.filePath = ""
        self.name = ""
        self.published = ""
        self.date = ""
    }
    
    init(version:String, filePath:String, name:String, published:String, date:String) {
        self.version = version
        self.filePath = filePath
        self.name = name
        self.published = published
        self.date = date
    }
    
    init(dict:[String:Any]) {
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
