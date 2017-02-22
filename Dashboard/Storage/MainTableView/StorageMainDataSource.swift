//
//  StorageMainDataSource.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class StorageMainDataSource: NSObject {

    var mainSettingsCount: Int = 0
    
    fileprivate var tableView: NSTableView
    
    init(tableView: NSTableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
    }
    
    func reload(count: Int) {
        self.mainSettingsCount = count
        self.tableView.reloadData()
        
    }
    
}

extension StorageMainDataSource: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.mainSettingsCount
    }
}
