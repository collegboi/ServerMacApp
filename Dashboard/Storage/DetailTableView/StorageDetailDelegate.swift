//
//  StorageDetailDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class StorageDetailDelegate: NSObject {
    
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
extension StorageDetailDelegate: NSOutlineViewDelegate {
    
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
    
    func getCellValue( item: Any ) -> ( key:String, value: String, type:String ) {
        
        if let record = item as? Document {
            
            if let value =  record.value as? String {
                
                return (record.key!,value,"String")
                
            } else {
                return (record.key!, "", "Object")
            }
        }
        return ("","","Object")
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        var view: NSTableCellView?
        var cellIdentifier: String = ""
        var textValue: String = ""
        
        let (key, value, type) = getCellValue(item: item)
        
        if tableColumn?.identifier == ColIdentifiers.KeyCol {
                
            cellIdentifier = CellIdentifiers.KeyCell
            textValue = key
                
        } else if tableColumn?.identifier == ColIdentifiers.ValueCol {
            
            cellIdentifier = CellIdentifiers.ValueCell
            textValue = value
        
        } else {
            cellIdentifier = CellIdentifiers.TypeCell
            textValue = type
        }
        
        view = outlineView.make(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView
            
        if let textField = view?.textField {
                
            textField.stringValue = textValue
            textField.sizeToFit()
        }
        return view
    }


}
