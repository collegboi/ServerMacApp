//
//  NotifcationViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 07/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

typealias SelectNotification = (_ exeception: TBNotification ) -> Void

class NotifcationViewDelegate: NSObject {
    
    var allNotification = [TBNotification]()
    
    var tableView: NSTableView
    var selectNotification: SelectNotification?
    
    fileprivate enum CellIdentifiers {
        static let IDCell = "IDCell"
        static let TimeStampCell = "TimeStampCell"
        static let MessageCell = "MessageCell"
        static let StatusCell = "StatusCell"
    }
    
    fileprivate enum ColIdentifiers {
        static let ID = "ID"
        static let TimeStamp = "TimeStamp"
        static let Message = "Message"
        static let Status = "Status"
    }
    
    
    init(tableView: NSTableView, selectNotification: @escaping SelectNotification) {
        self.tableView = tableView
        self.selectNotification = selectNotification
        super.init()
        self.tableView.delegate = self
    }
    
    func reload(_ allNotification: [TBNotification] ) {
        self.allNotification = allNotification
        self.tableView.reloadData()
    }
}

extension NotifcationViewDelegate: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        guard let tableView = notification.object as? NSTableView else {
            return
        }
        let selectedRow = tableView.selectedRow
        
        if selectedRow >= 0 {
            
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        let notification = self.allNotification[row]
        
        if tableColumn?.identifier == ColIdentifiers.ID {
            
            cellIdentifier = CellIdentifiers.IDCell
            text = notification.objectID
            
        }
        else  if tableColumn?.identifier == ColIdentifiers.TimeStamp  {
            
            cellIdentifier = CellIdentifiers.TimeStampCell
            text = notification.timeStamp
        }
        else if tableColumn?.identifier == ColIdentifiers.TimeStamp {
            
            cellIdentifier = CellIdentifiers.TimeStampCell
            text = notification.timeStamp
        }
        else if tableColumn?.identifier == ColIdentifiers.Message {
            
            cellIdentifier = CellIdentifiers.MessageCell
            text = notification.message
        }
        else if tableColumn?.identifier == ColIdentifiers.Status {
            
            cellIdentifier = CellIdentifiers.StatusCell
            text = notification.status
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
        
    }
    
}
