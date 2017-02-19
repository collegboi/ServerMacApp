//
//  AppViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

typealias SelectionApp = (_ exeception: TBApplication) -> Void

class AppViewDelegate: NSObject {
    
    var allApplications = [TBApplication]()
    
    var tableView: NSTableView
    var selectApp: SelectionApp?
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCell"
        static let AppIDCell = "AppIDCell"
        static let DBNameCell = "DBNameCell"
        static let AppKeyCell = "AppKeyCell"
    }
    
    fileprivate enum ColIdentifiers {
        static let NameCol = "NameCol"
        static let AppIDCol = "AppIDCol"
        static let DBNameCol = "DBNameCol"
        static let AppKeyCol = "AppKeyCol"
    }
    
    
    init(tableView: NSTableView, selectionBlock: @escaping SelectionApp) {
        self.tableView = tableView
        self.selectApp = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func reload(_ allApplications: [TBApplication] ) {
        self.allApplications = allApplications
        self.tableView.reloadData()
    }
}

extension AppViewDelegate: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        let selectedRow = tableView.selectedRow
        
        if selectedRow >= 0 {
            selectApp?(self.allApplications[selectedRow])
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        let application = self.allApplications[row]
        
        if application.name != "00" {
        
        
            if tableColumn?.identifier == ColIdentifiers.NameCol {
                
                cellIdentifier = CellIdentifiers.NameCell
                text = application.name
                
            }
            else  if tableColumn?.identifier == ColIdentifiers.AppIDCol  {
                
                cellIdentifier = CellIdentifiers.AppIDCell
                text = application.apID
                
            }
            else if tableColumn?.identifier == ColIdentifiers.DBNameCol {
                
                cellIdentifier = CellIdentifiers.DBNameCell
                text = application.databaseName
                
            }
            else if tableColumn?.identifier == ColIdentifiers.AppKeyCol {
                
                cellIdentifier = CellIdentifiers.AppKeyCell
                text = application.appKey
            }
            
            
            if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = text
                return cell
            }
        }
        
        return nil
        
    }
    
}
