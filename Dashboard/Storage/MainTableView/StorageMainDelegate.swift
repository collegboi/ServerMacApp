//
//  StorageMainDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

typealias SelectionDatabaseObject = (_ table: String) -> Void

class StorageMainDelegate: NSObject {
    
    var tableList = [Tables]()
    
    var tableView: NSTableView
    var objectSelectionBlock: SelectionDatabaseObject?

    
    init(tableView: NSTableView, selectionBlock: @escaping SelectionDatabaseObject) {
        self.tableView = tableView
        self.objectSelectionBlock = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func reload( tableList: [Tables] ) {
        self.tableList = tableList
        self.tableView.reloadData()
    }
}
extension StorageMainDelegate: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        let selectedRow = tableView.selectedRow
        
        if selectedRow >= 0 {
            objectSelectionBlock?(self.tableList[selectedRow].tableName)
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let cell = tableView.make(withIdentifier: "TableCell", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = self.tableList[row].tableName
            return cell
        }
        
        return nil
    }
}
