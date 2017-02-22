//
//  StaffTableViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//
import Foundation
import Cocoa

typealias SelectionStaff = (_ exeception: Staff ) -> Void

class StaffViewDelegate: NSObject {
    
    var allStaff = [Staff]()
    
    var tableView: NSTableView
    var selectStaff: SelectionStaff?
    
    fileprivate enum CellIdentifiers {
        static let UsernameCell = "UsernameCell"
        static let FirstNameCell = "FirstNameCell"
        static let LastNameCell = "LastNameCell"
        static let EmailCell = "EmailCell"
    }
    
    fileprivate enum ColIdentifiers {
        static let UsernameCol = "UsernameCol"
        static let FirstNameCol = "FirstNameCol"
        static let LastNameCol = "LastNameCol"
        static let EmailCol = "EmailCol"
    }
    
    
    init(tableView: NSTableView, selectionBlock: @escaping SelectionStaff) {
        self.tableView = tableView
        self.selectStaff = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func reload(_ allStaff: [Staff] ) {
        self.allStaff = allStaff
        self.tableView.reloadData()
    }
}

extension StaffViewDelegate: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        let selectedRow = tableView.selectedRow
        
        if selectedRow >= 0 {
            selectStaff?(self.allStaff[selectedRow])
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        let staff = self.allStaff[row]
            
        if tableColumn?.identifier == ColIdentifiers.UsernameCol {
            
            cellIdentifier = CellIdentifiers.UsernameCell
            text = staff.username
            
        }
        else if tableColumn?.identifier == ColIdentifiers.FirstNameCol  {
            
            cellIdentifier = CellIdentifiers.FirstNameCell
            text = staff.firstName
            
        }
        else if tableColumn?.identifier == ColIdentifiers.LastNameCol {
            
            cellIdentifier = CellIdentifiers.LastNameCell
            text = staff.lastName
            
        }
        else if tableColumn?.identifier == ColIdentifiers.EmailCol {
            
            cellIdentifier = CellIdentifiers.EmailCell
            text = staff.email
        }
        
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
        
    }
    
}
