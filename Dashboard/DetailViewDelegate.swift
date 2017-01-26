//
//  DetailViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 20/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa


class DetailViewDelegate: NSObject {
    
    var outlineView: NSOutlineView
    //var objectSelectionBlock: SelectionObject?
    
    fileprivate struct Constants {
        static let headerCellID = "MainHeaderCell"
        static let volumeCellID = "MainVolumeCell"
    }
    
    init(outlineView: NSOutlineView ) { // selectionBlock: @escaping SelectionObject) {
        self.outlineView = outlineView
        //self.objectSelectionBlock = selectionBlock
        super.init()
        self.outlineView.delegate = self
    }
}

extension DetailViewDelegate: NSOutlineViewDelegate {
    
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

