//
//  ViewCrashViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class ViewCrashViewController: NSViewController, NSWindowDelegate {
    
    var exception: Exceptions?
    var exceptionID: String?
    
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var reasonLabel: NSTextField!
    @IBOutlet weak var timeStampLabel: NSTextField!
    
    @IBOutlet weak var projectNameLabel: NSTextField!
    @IBOutlet weak var projectVersionLabel: NSTextField!
    @IBOutlet weak var osVersionLabel: NSTextField!
    @IBOutlet weak var mobileDeviceLabel: NSTextField!
    
    @IBOutlet var stackSymbolsTableView: NSTableView!
    @IBOutlet weak var createIssue: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createIssue.isEnabled = false
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
        
    }
    
    override func viewDidAppear() {
        
        self.view.window?.delegate = self
        
        if exception != nil {
            self.createIssue.isEnabled = true
            self.setupView()
        }
        else {
            
            if self.exceptionID != nil {
                
                self.exception = Exceptions()
                
                self.exception!.getInBackground(self.exceptionID!, ofType: Exceptions.self) { (succeeded: Bool, data: Exceptions ) -> () in
                 
                    DispatchQueue.main.async {
                        if (succeeded) {
                            self.exception = data
                            self.setupView()
                            print("scucess")
                        } else {
                            print("error")
                        }
                    }
                }
            }
        }
    }
    
    func setupView() {
        self.nameLabel.stringValue = exception!.exceptionName
        self.reasonLabel.stringValue = exception!.reason
        self.timeStampLabel.stringValue = exception!.timestamp
        self.projectNameLabel.stringValue = exception!.tags.buildName
        self.projectVersionLabel.stringValue = exception!.tags.buildVersion
        self.osVersionLabel.stringValue = exception!.tags.osVersion
        self.mobileDeviceLabel.stringValue = exception!.tags.deviceModel
        
        self.stackSymbolsTableView.dataSource = self
        self.stackSymbolsTableView.delegate = self
        
        self.stackSymbolsTableView.reloadData()
    }
    
    
    @IBAction func createIssue(_ sender: Any) {
        self.createNewIssue()
    }
    
    func createNewIssue() {
        
        let storyboard = NSStoryboard(name: "EditTickets", bundle: nil)
        let editIssueWindowController = storyboard.instantiateController(withIdentifier: "EditIssue") as! NSWindowController
        
        if let editIssueWindow = editIssueWindowController.window {
            
            let editIssueViewController = editIssueWindow.contentViewController as! EditIssueViewController
            editIssueViewController.issue = nil
            editIssueViewController.exceptionID = self.exception?.exceptionID
            
            let application = NSApplication.shared()
            application.runModal(for: editIssueWindow)
        }
    }

    
}

extension ViewCrashViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let cell = tableView.make(withIdentifier: "StackCell", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = self.exception!.stackSymbols[row]
            return cell
        }
        
        return nil
        
    }

}

extension ViewCrashViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.exception!.stackSymbols.count
    }
}
