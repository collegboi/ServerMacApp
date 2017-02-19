//
//  Tables.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation


struct Tables: JSONSerializable {
    
    var tableName: String!
    
    init() {
        
    }
    init(dict: String){
        self.tableName = dict
    }
    
    init(tableName: String) {
        self.tableName = tableName
    }
    
    init(dict: [String : Any]) {}
    
    init(dict: [String]) {
        
    }
}


struct Databases: JSONSerializable {
    
    var databaseName: String!
    
    init() {
        
    }
    init(dict: String){
        self.databaseName = dict
    }
    
    init(tableName: String) {
        self.databaseName = tableName
    }
    
    init(dict: [String : Any]) {}
    
    init(dict: [String]) {
        
    }
}
