//
//  TranslationKeysDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 04/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

typealias SelectionTranslationkey = (_ row: Int, _ key: String ) -> Void

class TranslationKeysDelegate: NSObject {
    
    var keys = [TranslationKeys]()
    
    var tableView: NSTableView
    var objectSelectionBlock: SelectionTranslationkey?
    
    init(tableView: NSTableView, selectionBlock: @escaping SelectionTranslationkey) {
        self.tableView = tableView
        self.objectSelectionBlock = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func reload( keys: [TranslationKeys] ) {
        self.keys = keys
        self.tableView.reloadData()
    }
}

extension TranslationKeysDelegate: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        let selectedRow = tableView.selectedRow
        
        if selectedRow < 0 {
            return
        }
        let item =  self.keys[selectedRow]
        
        objectSelectionBlock?(selectedRow, item.name)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let item = self.keys[row]
        
        if let cell = tableView.make(withIdentifier: "KeyCell", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = item.name
            return cell
        }
        
        return nil
    }
    
}
