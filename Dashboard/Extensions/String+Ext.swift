//
//  String+Ext.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

extension String {
 
    func readPlistString( value: String, _ defaultStr: String = "") -> String {
        var defaultURL = defaultStr
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            
            guard let valueStr = dict[value] as? String else {
                return defaultURL
            }
            
            defaultURL = valueStr
        }
        return defaultURL
    }
}
