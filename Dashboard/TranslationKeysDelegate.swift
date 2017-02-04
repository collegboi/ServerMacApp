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
    
    var keys = [String:String]()
    
    var tableView: NSTableView
    var objectSelectionBlock: SelectionTranslationkey?
    
    init(tableView: NSTableView, selectionBlock: @escaping SelectionTranslationkey) {
        self.tableView = tableView
        self.objectSelectionBlock = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func reload( keys: [String:String] ) {
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
        let (item,_) =  self.keys.getValueAtIndex(index: selectedRow)
        
        objectSelectionBlock?(selectedRow, item)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let (item,_) = self.keys.getValueAtIndex(index: row)
        
        if let cell = tableView.make(withIdentifier: "KeyCell", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = item
            return cell
        }
        
        return nil
    }
    
}
