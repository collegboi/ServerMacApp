//
//  Files.swift
//  Dashboard
//
//  Created by Timothy Barnard on 08/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation


struct Files: JSONSerializable {

    var _id : MBOjectID?
    var filePath: String = ""
    var timestamp: String = ""
    var fileSize: String = ""
    var fieldName: String = ""
    var type: String = ""
    
    init() {}
    init(dict: String) {}
    init(dict: [String]) {}
    
    init(dict: [String : Any]) {
        self._id?.objectID = dict.tryConvert(forKey: "_id")
        self.fieldName = dict.tryConvert(forKey: "fieldName")
        self.timestamp = dict.tryConvert(forKey: "timestamp")
        self.filePath = dict.tryConvert(forKey: "filePath")
        self.fileSize = dict.tryConvert(forKey: "fileSize")
        self.type = dict.tryConvert(forKey: "type")
    }
}
