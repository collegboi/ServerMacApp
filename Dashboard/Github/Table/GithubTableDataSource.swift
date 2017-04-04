//
//  GithubTableDataSource.swift
//  Dashboard
//
//  Created by Timothy Barnard on 02/04/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class GithubTableViewDataSource: NSObject {
    
    var rowCount: Int = 0
    
    fileprivate var tableView: NSTableView
    
    init(tableView: NSTableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
    }
    
    func reload(count: Int) {
        self.rowCount = count
        self.tableView.reloadData()
    }
}

extension GithubTableViewDataSource: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.rowCount
    }
}

