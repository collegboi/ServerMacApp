//
//  LanguagesDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 04/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa


typealias SelectionLanguage = (_ row: Int, _ language: Languages ) -> Void

class LanguagesDelegate: NSObject {
    
    var languages = [Languages]()
    
    var tableView: NSTableView
    var objectSelectionBlock: SelectionLanguage?
    
    init(tableView: NSTableView, selectionBlock: @escaping SelectionLanguage) {
        self.tableView = tableView
        self.objectSelectionBlock = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func reload( languages: [Languages] ) {
        self.languages = languages
        self.tableView.reloadData()
    }
}

extension LanguagesDelegate: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        let selectedRow = tableView.selectedRow
        
        if selectedRow < 0 {
            return
        }
        let item =  self.languages[selectedRow]
        
        objectSelectionBlock?(selectedRow, item)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let item = self.languages[row]
        
        if let cell = tableView.make(withIdentifier: "LanguageCell", owner: nil) as? NSTableCellView {
            
            cell.textField?.textColor = NSColor.black
            
            if item.available == 0 {
                cell.textField?.textColor = NSColor.gray
            }
            
            cell.textField?.stringValue = item.name
            return cell
        }
        
        return nil
    }
    
}
