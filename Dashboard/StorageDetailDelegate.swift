//
//  StorageDetailDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class StorageDetailDelegate: NSObject {
    
    var tableList = GenericTable()
    var dataArray:[AnyObject] = []
    
    var tableView: NSTableView
    var objectSelectionBlock: SelectionTableObject?
    
    let columnDefaultWidth:Float = 100.0
    
    init(tableView: NSTableView) { //selectionBlock: @escaping SelectionTableObject) {
        self.tableView = tableView
        //self.objectSelectionBlock = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func removeAllTableColumn() {
        let tColCount = self.tableView.tableColumns.count
        
        if tColCount > 0 {
            for columnVal in self.tableView.tableColumns {
                self.tableView.removeTableColumn(columnVal)
            }
        }
    }
    
    func setupTable() {
        
        self.tableView.rowHeight = 50
        
        for record  in self.tableList.columns {
            
            let tColumn:NSTableColumn = NSTableColumn(identifier: record )
            
            tColumn.headerCell.title = record
            
            tColumn.width = CGFloat(columnDefaultWidth)
            tColumn.minWidth = 150
            tColumn.maxWidth = 300
            
//            if (columnDictionary["columnType"] as! String == "check"){
//                let checkBox = NSButtonCell()
//                checkBox.setButtonType(.SwitchButton)
//                checkBox.title = ""
//                checkBox.alignment = .Right
//                tColumn.dataCell = checkBox
//                
//            }
            //else use the default text field cell
            //Applying sort descriptors to each column
            //let sortDescriptor = NSSortDescriptor( key: record , ascending: true, selector: #selector(NSNumber.compare(_:)))
            
            //tColumn.sortDescriptorPrototype = sortDescriptor
            
            self.tableView.addTableColumn(tColumn)
            
        }
        
        self.tableView.usesAlternatingRowBackgroundColors = true
        
        self.tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        
        //self.tableView.reloadData()
    }
    
    func reload( tableList: GenericTable ) {
        
        self.removeAllTableColumn()
    
        self.dataArray = tableList.row//NSMutableArray(array: tableList.row)
        self.tableList = tableList
        self.setupTable()
        
    }
}
extension StorageDetailDelegate: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var textView = tableView.make(withIdentifier: "textView", owner: self) as? NSTextView
        if textView == nil {
            textView = NSTextView()
            textView?.identifier = "textView"
        }
        
        if row < self.dataArray.count {
        
            if let object = self.dataArray[row] as? [String:AnyObject] {
                
                let text = object[tableColumn!.identifier]
                
                textView?.string = ""
                
                if let stringVal = text as? String {
                    textView?.string = stringVal
                }
            }
        }
        
        return textView
    }

    
//    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        var textView = tableView.make(withIdentifier: "textView", owner: self) as? NSTextView
//        if textView == nil {
//            textView = NSTextView()
//            textView?.identifier = "textView"
//        }
//        let object = self.dataArray.object(at: row)
//        textView?.string = "Test"
//        return textView
//    }
    
//    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
//        let item = self.dataArray[row] as AnyObject
//        return item
//    }
//    
//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//        return self.dataArray.object(at: row)
//    }
    
//    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject! {
//        
//        //let object = self.dataArray[row]
//        
//        return self.dataArray.object(at: row) as AnyObject!
//    }
    
//    func tableView(tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
//        
//        self.dataArray.sort(using: tableView.sortDescriptors)
//        
//        self.tableView.reloadData()
//    }

}
