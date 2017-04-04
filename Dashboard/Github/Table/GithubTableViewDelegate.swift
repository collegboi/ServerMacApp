//
//  GithubTableViewDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 02/04/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class GithubTableViewDelegate: NSObject {
    
    var allRepos = [Repos]()
    
    var tableView: NSTableView
    
    
    init(tableView: NSTableView ) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
    }
    
    func reload(_ allRepos: [Repos] ) {
        self.allRepos = allRepos
        self.tableView.reloadData()
    }
}

extension GithubTableViewDelegate: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let repo = self.allRepos[row]
        var cellIdentifier: String = ""
        var cellValue: String = ""
        
        if tableColumn?.identifier == "RepoNameCol" {
            cellIdentifier = "RepoNameCell"
            cellValue = repo.name
        } else {
            cellIdentifier = "RepoCommitsCell"
            cellValue = "\(repo.totalCommits)"
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = cellValue
            return cell
        }
        
        return nil
        
    }
    
}
