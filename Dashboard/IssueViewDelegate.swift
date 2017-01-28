//
//  IssueViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 28/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

typealias SelectionIssue = (_ issue: Issue) -> Void

class IssueViewDelegate: NSObject {
    
    var allIssues = [Issue]()
    
    var tableView: NSTableView
    var issueSelectionBlock: SelectionIssue?
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCell"
        static let StatusCell = "StatusCell"
        static let TypeCell = "TypeCell"
        static let AssigneeCell = "AssigneeCell"
        static let PriorityCell = "PriorityCell"
    }
    
    
    init(tableView: NSTableView, selectionBlock: @escaping SelectionIssue) {
        self.tableView = tableView
        self.issueSelectionBlock = selectionBlock
        super.init()
        self.tableView.delegate = self
    }
    
    func reload(_ allIssues: [Issue] ) {
        self.allIssues = allIssues
        self.tableView.reloadData()
    }
}

extension IssueViewDelegate: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
         issueSelectionBlock?(self.allIssues[row])
        
        return true
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        let issue = self.allIssues[row]
            
            if tableColumn?.identifier == "IssueName" {
                
                cellIdentifier = CellIdentifiers.NameCell
                text = issue.name
                
            }
            else  if tableColumn?.identifier == "IssueStatus"  {
                
                cellIdentifier = CellIdentifiers.StatusCell
                text = issue.status
            }
            else if tableColumn?.identifier == "IssueType" {
                
                cellIdentifier = CellIdentifiers.TypeCell
                text = issue.type
            }
            else if tableColumn?.identifier == "IssueAssignee" {
                
                cellIdentifier = CellIdentifiers.AssigneeCell
                text = issue.assingee
            }
            else if tableColumn?.identifier == "IssuePriority" {
                
                cellIdentifier = CellIdentifiers.PriorityCell
                text = issue.prioity
            }
        
        
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil

    }
    
}
