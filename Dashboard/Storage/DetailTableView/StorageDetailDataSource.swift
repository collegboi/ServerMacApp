//
//  StorageDetailDataSource.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class StorageDetailDataSource: NSObject {

    var records: [Document]?
    
    fileprivate var outlineView: NSOutlineView
    
    init(outlineView: NSOutlineView) {
        self.outlineView = outlineView
        super.init()
        self.outlineView.dataSource = self
    }
    
    func reload(records: [Document]) {
        self.records = records
        self.outlineView.reloadData()
    }
    
}

extension StorageDetailDataSource: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if let child = item as? Document {
            return child.hasChildren
        }
        
        guard let contollerCount = self.records?.count else {
            return 0
        }
        
        return contollerCount
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        if let record = item as? Document {
            return record.children![index]
        }
        return self.records![index]
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        if let parent = item as? Document {
            return parent.hasChildren > 0
        }
        
        return false
    }
}
