//
//  VersionViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

typealias SelectionVersion = (_ appVersion: TBAppVersion) -> Void

class VersionViewDelegate: NSObject {
    
    var allVersions = [TBAppVersion]()
    
    var tableView: NSTableView
    var selectApp: SelectionVersion?
    
    fileprivate enum CellIdentifiers {
        static let VersionCell = "VersionCell"
        static let DateCell = "DateCell"
        static let NotesCell = "NotesCell"
    }
    
    fileprivate enum ColIdentifiers {
        static let VersionCol = "VersionCol"
        static let DateCol = "DateCol"
        static let NotesCol = "NotesCol"
    }
    
    
    init(tableView: NSTableView, selectionBlock: @escaping SelectionVersion) {
        self.tableView = tableView
        self.selectApp = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func reload(_ allVersions: [TBAppVersion] ) {
        self.allVersions = allVersions
        self.tableView.reloadData()
    }
}

extension VersionViewDelegate: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        let selectedRow = tableView.selectedRow
        
        if selectedRow >= 0 {
            selectApp?(self.allVersions[selectedRow])
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        let application = self.allVersions[row]
        
        if tableColumn?.identifier == ColIdentifiers.VersionCol {
            
            cellIdentifier = CellIdentifiers.VersionCell
            text = application.version
            
        }
        else  if tableColumn?.identifier == ColIdentifiers.DateCol  {
            
            cellIdentifier = CellIdentifiers.DateCell
            text = application.date
            
        }
        
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
        
    }
    
}

