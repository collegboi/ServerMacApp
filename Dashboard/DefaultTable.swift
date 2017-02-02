//
//  DefaultTable.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

//struct GenericProp: JSONSerializable {
//    
//    var key: String!
//    var value: String!
//    
//    init() {}
//    init(dict: [String]) {}
//    init(dict: String) {}
//    init(dict: [String : Any]) {}
//    
//    init(key: String, value: String) {
//        self.key = key
//        self.value = value
//    }
//}
//
//struct GenericTable: JSONSerializable {
//    
//    var row: [GenericProp]!
//    
//    init() {}
//    init(dict: [String]) {}
//    init(dict: String) {}
//    
//    init(dict: [String : Any]) {
//        
//        for (key, value) in dict {
//            
//            let genericProp = GenericProp(key: key, value: value as? String ?? "")
//            self.row.append(genericProp)
//        }
//        
//    }
//
//}


struct GenericTable: JSONSerializable {
    
    var row: [AnyObject]!
    var columns: [String]!
    
    init() {}
    init(dict: [String : Any]) {}
    
    init(dict: [String]) {}
    init(dict: String) {}
    
    init(dict: [AnyObject], columns: [String]) {
        self.row = dict
        self.columns = columns
    }
    
}
