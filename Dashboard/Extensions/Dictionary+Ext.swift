//
//  Dictionary+Ext.swift
//  Dashboard
//
//  Created by Timothy Barnard on 20/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func getValueAtIndex( index: Int ) -> ( String, String ) {
        for( indexVal, value) in enumerated() {
            
            if indexVal == index {
                return ( "\(value.0)" , "\(value.1)" )
            }
        }
        
        return ("", "")
    }
    
    func getKeyValueAtIndex( index: Int ) -> KeyValuePair {
        for( indexVal, value) in enumerated() {
            
            if indexVal == index {
                return KeyValuePair(key: "\(value.0)", value:  "\(value.1)")
            }
        }
        
        return KeyValuePair(key: "", value: "")
    }
    
    
    func getObjectAtIndex( index: Int ) -> ( String, AnyObject ) {
        
        for( indexVal, value) in enumerated() {
            
            if indexVal == index {
                return ( "\(value.0)" , value.1 as AnyObject )
            }
        }
        
        return ("", "" as AnyObject)
    }
}
