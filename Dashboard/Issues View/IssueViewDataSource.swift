//
//  IssueViewDataSource.swift
//  Dashboard
//
//  Created by Timothy Barnard on 28/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class IssueViewDataSource: NSObject {
    
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

extension IssueViewDataSource: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.issueCount
    }
}
