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

struct Document: JSONSerializable {
    
    var hasChildren: Int = 0
    var key: String?
    var value : AnyObject?
    var children: [Document]?
    
    init() {}
    init(dict: [String : Any]) {}
    
    init(dict: [String]) {}
    init(dict: String) {}
    
    init( key: String, value: AnyObject, children: [Document] = [], hasChildren: Int = 0 ) {
        self.key = key
        self.value = value
        self.children = children
        self.hasChildren = hasChildren
    }
}

struct GenericTable: JSONSerializable {
    
    var row: [Document]!
    
    init() {}
    init(dict: [String : Any]) {}
    
    init(dict: [String]) {}
    init(dict: String) {}
    
    init(dict: [Document]) {
        self.row = dict
    }
    
}
