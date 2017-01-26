//
//  ColorViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa


typealias SelectionSettingColor = (_ key: String, _ value: NSColor ) -> Void

class ColorViewDelegate: NSObject {
    
    var colorSettings = [RCColor]()
    
    var tableView: NSTableView
    var objectSelectionBlock: SelectionSettingColor?
    
    fileprivate enum CellIdentifiers {
        static let SettingsCell1 = "ColorCell1"
        static let SettingsCell2 = "ColorCell2"
    }
    
    
    init(tableView: NSTableView, selectionBlock: @escaping SelectionSettingColor) {
        self.tableView = tableView
        self.objectSelectionBlock = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func reload( colorSettings: [RCColor] ) {
        self.colorSettings = colorSettings
        self.tableView.reloadData()
    }
}

extension ColorViewDelegate: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        let selectedRow = tableView.selectedRow
        guard let item =  self.colorSettings[selectedRow] as? RCColor , selectedRow >= 0 else {
            return
        }
        let color = NSColor(red: item.red/255.0, green: item.green/255.0, blue: item.blue/255.0, alpha: item.alpha)
        objectSelectionBlock?(item.name, color)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        var color = NSColor()
        color = NSColor.white
        
        let item = colorSettings[row]

        if tableColumn == tableView.tableColumns[0] {
            text = item.name
            cellIdentifier = CellIdentifiers.SettingsCell1
        } else if tableColumn == tableView.tableColumns[1] {
            color = NSColor(red: item.red/255.0, green: item.green/255.0, blue: item.blue/255.0, alpha: item.alpha)
            cellIdentifier = CellIdentifiers.SettingsCell2
        }

        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.wantsLayer = true
            cell.layer?.backgroundColor = color.cgColor
            return cell
        }
        
        
        return nil
    }
    
}
