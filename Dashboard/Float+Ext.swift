//
//  Float+Ext.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

extension Float {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}


extension CGFloat {
    var radians: CGFloat {
        return self * CGFloat(2 * M_PI / 360)
    }
    
    var degrees: CGFloat {
        return 360.0 * self / CGFloat(2 * M_PI)
    }
}
