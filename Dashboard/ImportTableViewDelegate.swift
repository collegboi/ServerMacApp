//
//  ImportTableViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 08/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class ImportTableDelegate: NSObject {
    
    var outlineView: NSOutlineView
    
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
    
    init(outlineView: NSOutlineView) {
        self.outlineView = outlineView
        super.init()
        self.outlineView.delegate = self
    }
    
}
extension ImportTableDelegate: NSOutlineViewDelegate {

    
    func getCellValue( item: Any ) -> ( key:String, value: String) {
        
        if let (key, value) = item as? (String, String) {
            return (key, value)
        }
        return ("","")
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
