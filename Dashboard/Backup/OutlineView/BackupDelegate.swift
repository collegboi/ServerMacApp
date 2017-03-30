//
//  BackupDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 18/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

class BackupDelegate: NSObject {
    
    var outlineView: NSOutlineView
    var objectSelectionBlock: SelectionTableObject?
    
    fileprivate struct ColIdentifiers {
        static let ValueCol = "ValueCol"
        static let KeyCol = "KeyCol"
        static let TypeCol = "TypeCol"
    }
    
    fileprivate struct CellIdentifiers {
        static let ValueCell = "ValueCell"
        static let KeyCell = "KeyCell"
        static let TypeCell = "TypeCell"
    }
    
    init(outlineView: NSOutlineView) { //selectionBlock: @escaping SelectionTableObject) {
        self.outlineView = outlineView
        //self.objectSelectionBlock = selectionBlock
        super.init()
        self.outlineView.delegate = self
    }
    
}
extension BackupDelegate: NSOutlineViewDelegate {
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        /*guard let outlineView = notification.object as? NSOutlineView else {
         return
         }
         let selectedRow = outlineView.selectedRow*/
        //guard let item = outlineView.item(atRow: selectedRow) as? RCObject , selectedRow >= 0 else {
        //    return
        //}
        //objectSelectionBlock?(item)
    }
    
    func getCellValue( item: Any ) -> ( key:String, value: String) {
        
        guard let backup = item as? TBBackups else {
            return ("","")
        }
        
        return (backup.created,backup.path_backup)
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        var view: NSTableCellView?
        var cellIdentifier: String = ""
        var textValue: String = ""
        
        let (key, value) = getCellValue(item: item)
        
        if tableColumn?.identifier == ColIdentifiers.KeyCol {
            
            cellIdentifier = CellIdentifiers.KeyCell
            textValue = key
            
        } else if tableColumn?.identifier == ColIdentifiers.ValueCol {
            
            cellIdentifier = CellIdentifiers.ValueCell
            textValue = value
            
        }
        
        view = outlineView.make(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
        
        if let textField = view?.textField {
            
            textField.stringValue = textValue
            textField.sizeToFit()
        }
        return view
    }
    
    
}
