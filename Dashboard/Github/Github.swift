//
//  Github.swift
//  Dashboard
//
//  Created by Timothy Barnard on 02/04/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

class Repos {
    
    var name: String = ""
    var fullName: String = ""
    var size: String = ""
    var totalCommits: Int = 0
    var double_size: Int = 0
    
    
    init(dictionary: Dictionary<String, AnyObject>) {
        self.name = dictionary.tryConvert(forKey: "name")
        self.fullName = dictionary.tryConvert(forKey: "full_name")
        self.double_size = dictionary.tryConvert(forKey: "size")
    }
    
}
