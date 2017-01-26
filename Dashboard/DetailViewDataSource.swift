//
//  DetailViewDataSource.swift
//  Dashboard
//
//  Created by Timothy Barnard on 20/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class DetailViewDataSource: NSObject {
    
    var keyValuePairs = [String:Any]()
    
    fileprivate var outlineView: NSOutlineView
    
    init(outlineView: NSOutlineView) {
        self.outlineView = outlineView
        super.init()
        self.outlineView.dataSource = self
    }
    
    func reload( keyValuePairs: [String:Any]  ) {
        self.keyValuePairs = keyValuePairs
        self.outlineView.reloadData()
    }
    
}

extension DetailViewDataSource: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        return self.keyValuePairs.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        return self.keyValuePairs.getKeyValueAtIndex(index: index)
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
}
