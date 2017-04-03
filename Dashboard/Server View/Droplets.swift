//
//  Droplets.swift
//  Dashboard
//
//  Created by Timothy Barnard on 02/04/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

class Droplets {
    
    var name: String = ""
    var status: String = ""
    var IPV4: String = ""
    var IPV6: String = ""
    var imageName:String = ""
    var imageDistribution:String = ""
    
    
    init(dictionary: Dictionary<String, AnyObject>) {
        self.name = dictionary.tryConvert(forKey: "name")
        self.status = dictionary.tryConvert(forKey: "status")
        
        let image = dictionary.tryConvertObj(forKey: "image")
        
        if !image.isEmpty {
            self.imageName = image.tryConvert(forKey: "name")
            self.imageDistribution = image.tryConvert(forKey: "distribution")
        }
        
        let networks = dictionary.tryConvertObj(forKey: "networks")
        
        if !networks.isEmpty {
            
            let IPV4s = networks.tryConvertArry(forKey: "v4")
            
            if IPV4s.count > 1 {
            
                guard let IPV4Public = IPV4s[1] as? [String:AnyObject] else {
                    return
                }
                self.IPV4 = IPV4Public.tryConvert(forKey: "ip_address")
            }
            
            let IPV6s = networks.tryConvertArry(forKey: "v6")
            
            if IPV6s.count > 0 {
                
                guard let IPV6Public = IPV6s[0] as? [String:AnyObject] else {
                    return
                }
                self.IPV6 = IPV6Public.tryConvert(forKey: "ip_address")
            }
        }
    }
    
}
