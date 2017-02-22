//
//  DatabaseViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

typealias SelectionTableObject = (_ table: String) -> Void

class DatabaseViewDelegate: NSObject {
    
    var tableList = [TBApplication]()
    
    var tableView: NSTableView
    var objectSelectionBlock: SelectionTableObject?
    
    
    init(tableView: NSTableView, selectionBlock: @escaping SelectionTableObject) {
        self.tableView = tableView
        self.objectSelectionBlock = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func reload( tableList: [TBApplication] ) {
        self.tableList = tableList
        self.tableView.reloadData()
    }
}
extension DatabaseViewDelegate: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        let selectedRow = tableView.selectedRow
        
        if selectedRow >= 0 {
            objectSelectionBlock?(self.tableList[selectedRow].appKey)
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let cell = tableView.make(withIdentifier: "TableCell", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = self.tableList[row].databaseName
            return cell
        }
        
        return nil
    }
}
