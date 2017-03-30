//
//  BackupDataSource.swift
//  Dashboard
//
//  Created by Timothy Barnard on 18/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

class BackupDataSource: NSObject {
    
    var backups: [TBBackups]?
    
    fileprivate var outlineView: NSOutlineView
    
    init(outlineView: NSOutlineView) {
        self.outlineView = outlineView
        super.init()
        self.outlineView.dataSource = self
    }
    
    func reload(backups: [TBBackups]) {
        self.backups = backups
        self.outlineView.reloadData()
    }
}

extension BackupDataSource: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if let child = item as? [String] {
            return child.count
        }
        
        guard let contollerCount = self.backups?.count else {
            return 0
        }
        
        return contollerCount
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        if let record = item as? [String] {
            return record[index]
        }
        return self.backups![index]
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        if let parent = item as? [String] {
            return parent.count > 0
        }
        
        return false
    }
}
