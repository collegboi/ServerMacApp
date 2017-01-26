//
//  NSFont+Ext.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

extension NSFont {
    
    static var barChartLegendNameFont: NSFont {
        return NSFont.boldSystemFont(ofSize: 11.0)
    }
    
    static var barChartLegendSizeTextFont: NSFont {
        return NSFont.systemFont(ofSize: 11.0)
    }
    
    static var pieChartLegendFont: NSFont {
        return NSFont.systemFont(ofSize: 9.0)
    }
}
