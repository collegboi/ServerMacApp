//
//  SystemStatus.swift
//  Dashboard
//
//  Created by Timothy Barnard on 12/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation


struct CPUStats {
    
    var idle: Double!
    var system: Double!
    var user: Double!
    
    init(dict: [String:Any]) {
        self.idle = dict.tryConvert(forKey: "idle")
        self.system = dict.tryConvert(forKey: "system")
        self.user = dict.tryConvert(forKey: "user")
    }
}

struct MemoryStats {
    
    var avialable: Double!
    var free: Double!
    var total: Double!
    var used: Double!
    
    init(dict: [String:Any]) {
        self.used = dict.tryConvert(forKey: "used")
        self.avialable = dict.tryConvert(forKey: "avilable")
        self.total = dict.tryConvert(forKey: "total")
        self.free = dict.tryConvert(forKey: "free")
    }
}


struct StorageStats {
    
    var avialable: Double!
    var total: Double!
    var used: Double!
    
    init(dict: [String:Any]) {
        self.avialable = dict.tryConvert(forKey: "avilable")
        self.total = dict.tryConvert(forKey: "size")
        self.used = dict.tryConvert(forKey: "used")
    }
}


struct SystemStatus {
    
    var cpu: CPUStats!
    var memory: MemoryStats!
    var storage: StorageStats!
    
    init( dict: [String:Any] ) {
        
        self.cpu = CPUStats(dict: dict["cpu"] as! [String : Any])
        self.memory = MemoryStats(dict: dict["memory"] as! [String : Any])
        self.storage = StorageStats(dict: dict["storage"] as! [String : Any])
    }
}
