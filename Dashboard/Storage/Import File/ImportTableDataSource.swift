//
//  ImportTableDataSource.swift
//  Dashboard
//
//  Created by Timothy Barnard on 08/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

class ImportTableDataSource: NSObject {
    
    var records: [[String:String]]?
    
    fileprivate var outlineView: NSOutlineView
    
    init(outlineView: NSOutlineView) {
        self.outlineView = outlineView
        super.init()
        self.outlineView.dataSource = self
    }
    
    func reload(records: [[String:String]]) {
        self.records = records
        self.outlineView.reloadData()
    }
    
}

extension ImportTableDataSource: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if let child = item as? [String:String] {
            return child.count
        }
        
        guard let contollerCount = self.records?.count else {
            return 0
        }
        
        return contollerCount
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        if let record = item as? [String:String] {
            return record.getValueAtIndex(index: index)
        }
        return self.records![index]
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        if let parent = item as? [String:String] {
            return parent.count > 0
        }
        return false
    }
}
