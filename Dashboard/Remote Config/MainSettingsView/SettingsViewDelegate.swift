//
//  SettingsViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 21/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

typealias SelectionSettingObject = (_ key: String, _ value: String, _ row: Int) -> Void

class SettingsViewDelegate: NSObject {
    
    var mainSettings = [String:String]()
    
    var tableView: NSTableView
    var objectSelectionBlock: SelectionSettingObject?
    
    fileprivate enum CellIdentifiers {
        static let SettingsCell1 = "SettingsCell1"
        static let SettingsCell2 = "SettingsCell2"
    }
    
    
    init(tableView: NSTableView, selectionBlock: @escaping SelectionSettingObject) {
        self.tableView = tableView
        self.objectSelectionBlock = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func reload( mainSettings: [String:String] ) {
        self.mainSettings = mainSettings
        self.tableView.reloadData()
    }
}

extension SettingsViewDelegate: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        let selectedRow = tableView.selectedRow
        if selectedRow < 0 {
            return
        }
        let keyValuePair = self.mainSettings.getKeyValueAtIndex(index: selectedRow)
        
        objectSelectionBlock?(keyValuePair.key, keyValuePair.value, selectedRow)
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        var text: String = ""
        var cellIdentifier: String = ""
        
        // 1
        let item = mainSettings.getKeyValueAtIndex(index: row)
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = item.key
            cellIdentifier = CellIdentifiers.SettingsCell1
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.value
            cellIdentifier = CellIdentifiers.SettingsCell2
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }

}

