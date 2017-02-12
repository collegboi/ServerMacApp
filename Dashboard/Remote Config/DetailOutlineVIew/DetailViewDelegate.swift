//
//  DetailViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 20/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

typealias SelectionRCObject = (_ row: Int, _ object: KeyValuePair ) -> Void

class DetailViewDelegate: NSObject {
    
    var outlineView: NSOutlineView
    var objectSelectionBlock: SelectionRCObject?
    
    fileprivate struct Constants {
        static let headerCellID = "MainHeaderCell"
        static let volumeCellID = "MainVolumeCell"
    }
    
    init(outlineView: NSOutlineView , selectionBlock: @escaping SelectionRCObject) {
        self.outlineView = outlineView
        self.objectSelectionBlock = selectionBlock
        super.init()
        self.outlineView.delegate = self
    }
}

extension DetailViewDelegate: NSOutlineViewDelegate {
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        let selectedRow = outlineView.selectedRow
        guard let item = outlineView.item(atRow: selectedRow) as? KeyValuePair , selectedRow >= 0 else {
            return
        }
        objectSelectionBlock?( selectedRow, item)
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        var view: NSTableCellView?
        
        if let keyValuePair = item as? KeyValuePair {
            
            if tableColumn?.identifier == "KeyCol" {
                
                view = outlineView.make(withIdentifier: "Cell1", owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
                    
                    textField.stringValue = keyValuePair.key
                    textField.sizeToFit()
                }
                
            } else {
                
                view = outlineView.make(withIdentifier: "Cell2", owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
                    
                    textField.stringValue = keyValuePair.value
                    textField.sizeToFit()
                }
            }
        }
        return view
    }
}

