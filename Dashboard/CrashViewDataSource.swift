//
//  CrashViewDataSource.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

class CrashViewDataSource: NSObject {
    
    var issueCount: Int = 0
    
    fileprivate var tableView: NSTableView
    
    init(tableView: NSTableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
    }
    
    func reload(count: Int) {
        self.issueCount = count
        self.tableView.reloadData()
        
    }
    
}

extension CrashViewDataSource: NSTableViewDataSource {

    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.issueCount
    }
}
