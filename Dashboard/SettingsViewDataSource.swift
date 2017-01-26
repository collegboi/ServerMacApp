//
//  SettingsViewDataSource.swift
//  Dashboard
//
//  Created by Timothy Barnard on 21/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class SettingsViewDataSource: NSObject {
    
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

extension SettingsViewDataSource: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.mainSettingsCount
    }
}
