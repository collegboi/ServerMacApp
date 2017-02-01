//
//  CrashViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

import Cocoa

typealias SelectionCrash = (_ exeception: Exceptions) -> Void

class CrashViewDelegate: NSObject {
    
    var allExceptions = [Exceptions]()
    
    var tableView: NSTableView
    var crashSelectionBlock: SelectionCrash?
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCell"
        static let TimeCell = "TimeCell"
        static let ReasonCell = "ReasonCell"
        static let ProjNameCell = "ProjNameCell"
        static let ProjVersionCell = "ProjVersionCell"
        static let LevelCell = "LevelCell"
    }
    
    fileprivate enum ColIdentifiers {
        static let ExceptionName = "ExceptionName"
        static let TimeStamp = "TimeStamp"
        static let ExceptionReason = "ExceptionReason"
        static let ProjectName = "ProjectName"
        static let ProjectVersion = "ProjectVersion"
        static let ExceptionLevel = "ExceptionLevel"
    }
    
    
    init(tableView: NSTableView, selectionBlock: @escaping SelectionCrash) {
        self.tableView = tableView
        self.crashSelectionBlock = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func reload(_ allExceptions: [Exceptions] ) {
        self.allExceptions = allExceptions
        self.tableView.reloadData()
    }
}

extension CrashViewDelegate: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        let selectedRow = tableView.selectedRow
        
        if selectedRow >= 0 {
            crashSelectionBlock?(self.allExceptions[selectedRow])
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        let exeception = self.allExceptions[row]
        
        if tableColumn?.identifier == ColIdentifiers.ExceptionName {
            
            cellIdentifier = CellIdentifiers.NameCell
            text = exeception.exceptionName
            
        }
        else  if tableColumn?.identifier == ColIdentifiers.ExceptionLevel  {
            
            cellIdentifier = CellIdentifiers.LevelCell
            text = exeception.level
        }
        else if tableColumn?.identifier == ColIdentifiers.TimeStamp {
            
            cellIdentifier = CellIdentifiers.TimeCell
            text = exeception.timestamp
        }
        else if tableColumn?.identifier == ColIdentifiers.ExceptionReason {
            
            cellIdentifier = CellIdentifiers.ReasonCell
            text = exeception.reason
        }
        else if tableColumn?.identifier == ColIdentifiers.ProjectName {
            
            cellIdentifier = CellIdentifiers.ProjNameCell
            text = exeception.tags.buildName
        }
        else if tableColumn?.identifier == ColIdentifiers.ProjectVersion {
            cellIdentifier = CellIdentifiers.ProjVersionCell
            text = exeception.tags.buildVersion
        }
        
        
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
        
    }
    
}
