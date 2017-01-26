//
//  ColorViewDataSource.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class ColorViewDataSource: NSObject {
    
    var colorsCount: Int = 0
    
    fileprivate var tableView: NSTableView
    
    init(tableView: NSTableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
    }
    
    func reload(count: Int) {
        self.colorsCount = count
        self.tableView.reloadData()
        
    }
    
}

extension ColorViewDataSource: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.colorsCount
    }
    
}


import Cocoa

class CustomTableCellView: NSTableCellView {
    
    @IBOutlet weak var colorView: NSView!
    
}

