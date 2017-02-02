//
//  TestObject.swift
//  Dashboard
//
//  Created by Timothy Barnard on 29/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

struct TestObject: JSONSerializable {
    
    var issueID: MBOjectID = MBOjectID.init(objectID: "")
    var name: String!
    var status: String!
    var type: String!
    var assingee: String!
    var prioity: String!
    var version: String!
    
    init() {
        
    }
    
    init(dict: [String]) {}
    
    init(dict: String) {}
    
    init(name: String, status: String, type: String, assignee: String, priority: String, version: String) {
        self.name = name
        self.status = status
        self.type = type
        self.assingee = assignee
        self.prioity = priority
        self.version = version
    }
    
    
    init( dict: [String:Any] ) {
        self.name = dict["name"] as! String
        self.version = "1.2.2"//dict["version"] as! String
        self.status = dict["status"] as! String
        self.assingee = dict["assingee"] as! String
        self.type = dict["type"] as! String
        self.prioity = dict["prioity"] as! String
        self.issueID = MBOjectID.init(objectID: dict["_id"] as! String)
    }
}
