//
//  GenericTableViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

class GenericTableViewDelegate: NSObject {
    
    var allStrings = [String]()
    
    var tableView: NSTableView

    
    init(tableView: NSTableView ) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
    }
    
    func reload(_ allStrings: [String] ) {
        self.allStrings = allStrings
        self.tableView.reloadData()
    }
}

extension GenericTableViewDelegate: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let rowString = self.allStrings[row]
        
        if let cell = tableView.make(withIdentifier: "StringCell", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = rowString
            return cell
        }
        
        return nil
        
    }
    
}
