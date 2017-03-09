//
//  MainViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 20/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

typealias SelectionObject = (_ volume: RCObject?, _ rcController: RCController? , _ row: Int, _ parent: Int) -> Void

class MainViewDelegate: NSObject {
    
    var outlineView: NSOutlineView
    var objectSelectionBlock: SelectionObject?
    
    fileprivate struct Constants {
        static let headerCellID = "MainHeaderCell"
        static let volumeCellID = "MainVolumeCell"
    }
    
    init(outlineView: NSOutlineView, selectionBlock: @escaping SelectionObject) {
        self.outlineView = outlineView
        self.objectSelectionBlock = selectionBlock
        super.init()
        self.outlineView.delegate = self
    }
}

extension MainViewDelegate: NSOutlineViewDelegate {
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        let selectedRow = outlineView.selectedRow
        
        if let item = outlineView.item(atRow: selectedRow) as? RCController {
            
            if selectedRow >= 0 {
                objectSelectionBlock?(nil, item, selectedRow, selectedRow)
            }
        }
        else if let item = outlineView.item(atRow: selectedRow) as? RCTableObject {
            
            if selectedRow >= 0 {
                
                let object = item.rcObject
                let parentRow = item.parentRow
                
                objectSelectionBlock?(object, nil, item.row, parentRow!)
            }
            
        }
        
        //objectSelectionBlock?(object!, selectedRow, parentRow!)
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        var view: NSTableCellView?
        
        if let contoller = item as? RCController {
            
            if tableColumn?.identifier == "ValueColumn" {
                
                view = outlineView.make(withIdentifier: "KeyCell", owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
                    textField.stringValue = ""
                    textField.sizeToFit()
                }
                
            } else {
                
                view = outlineView.make(withIdentifier: "ValueCell", owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
                    
                    textField.stringValue = contoller.name
                    textField.sizeToFit()
                }
            }
            
        } else if let objectItem = item as? RCTableObject {
            
            if tableColumn?.identifier == "ValueColumn" {
                
                view = outlineView.make(withIdentifier: "ValueCell", owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
                    
                    textField.stringValue = objectItem.rcObject.objectName
                    textField.sizeToFit()
                }
            } else {
                
                view = outlineView.make(withIdentifier: "KeyCell", owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
                    
                    textField.stringValue = objectItem.rcObject.objectType.rawValue
                    textField.sizeToFit()
                }
                
            }
            
        }
        
        return view
    }
}

