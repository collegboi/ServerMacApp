//
//  Backup.swift
//  Dashboard
//
//  Created by Timothy Barnard on 18/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation


struct TBBackupSetting: JSONSerializable {
    
    var id: MBOjectID!
    var hostname: String!
    var username: String!
    var password: String!
    var schedule: String!
    var time: String!
    var path: String!
    var doBackups:String!
    var type: String!
    
    init(hostname:String, username: String, password: String, time:String, schedule: String, path: String, doBackups:String, type: String) {
        self.hostname = hostname
        self.username = username
        self.password = password
        self.time = time
        self.schedule = schedule
        self.path = path
        self.id = MBOjectID(objectID: "")
        self.doBackups = doBackups
        self.type = type
    }
    
    init() {}
    
    init(dict: [String]) {}
    
    init(dict: String) {}
    
    init(dict: [String : Any]) {
        //self.id.objectID = dict.tryConvert(forKey: "_id")
        self.hostname = dict.tryConvert(forKey: "hostname")
        self.username = dict.tryConvert(forKey: "username")
        self.password = dict.tryConvert(forKey: "password")
        self.time = dict.tryConvert(forKey: "time")
        self.schedule = dict.tryConvert(forKey: "schedule")
        self.path = dict.tryConvert(forKey: "path")
        self.doBackups = dict.tryConvert(forKey: "doBackups")
        self.type = dict.tryConvert(forKey: "type")
    }
    
}

struct TBBackups: JSONSerializable {
    
    var id: MBOjectID!
    var path_backup: String!
    var collections: [String]!
    var created: String!
    
    init(path_backup:String, collections: [String], created: String) {
        self.path_backup = path_backup
        self.collections = collections
        self.created = created
        self.id = MBOjectID(objectID: "")
    }
    
    init() {}
    
    init(dict: [String]) {}
    
    init(dict: String) {}
    
    init(dict: [String : Any]) {
        //self.id.objectID = dict.tryConvert(forKey: "_id")
        self.path_backup = dict.tryConvert(forKey: "path_backup")
        self.collections = dict.tryConvert(forKey: "collections")
        self.created = dict.tryConvert(forKey: "created")
    }
    
}
