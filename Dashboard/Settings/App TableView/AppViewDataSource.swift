//
//  AppViewDataSource.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//
import Foundation
import Cocoa

class AppViewDataSource: NSObject {
    
    var appCount: Int = 0
    
    fileprivate var tableView: NSTableView
    
    init(tableView: NSTableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
    }
    
    func reload(count: Int) {
        self.appCount = count
        self.tableView.reloadData()
        
    }
    
}

extension AppViewDataSource: NSTableViewDataSource {
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.appCount
    }
}
