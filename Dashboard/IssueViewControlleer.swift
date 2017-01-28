//
//  IssueViewControlleer.swift
//  Dashboard
//
//  Created by Timothy Barnard on 28/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class IssueViewControlleer: NSViewController {
    
    @IBOutlet var issuesTableView: NSTableView!
    
    @IBOutlet var newIssueButton: NSButton!
    
    fileprivate var issueViewDelegate: IssueViewDelegate!
    fileprivate var issueViewDataSource: IssueViewDataSource!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        issueViewDataSource = IssueViewDataSource(tableView: issuesTableView)
        issueViewDelegate = IssueViewDelegate(tableView: issuesTableView) { issue in
            self.editIssue(issue: issue)
        }
        
        self.getAllIssues()
    }
    
    
    @IBAction func newIssueButton(_ sender: Any) {
        
        let newIssue = Issue(name: "", status: "", type: "", assignee: "", priority: "", version: "")
        self.editIssue(issue: newIssue)
    }
    
    func editIssue(issue: Issue) {
            
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let editIssueWindowController = storyboard.instantiateController(withIdentifier: "EditIssue") as! NSWindowController
            
        if let editIssueWindow = editIssueWindowController.window {
                
            let editIssueViewController = editIssueWindow.contentViewController as! EditIssueViewController
            editIssueViewController.issue = issue
            editIssueViewController.delegate = self
                
            let application = NSApplication.shared()
            application.runModal(for: editIssueWindow)
        }
    }
    
    func getAllIssues() {
        
        let apiEndpoint = "http://0.0.0.0:8181/"
        
        print("sendRawTimetable")
        let networkURL = apiEndpoint + "tracker/Issue"
        let dic = [String:AnyObject]()
        HTTPSConnection.httpGetRequest(params: dic, url: networkURL) { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            DispatchQueue.main.async {
                if (succeeded) {
                    print("Succeeded")
                    let issues = IssueJSON.parseJSONConfig(data: data as Data)
                    
                    self.issueViewDelegate.reload(issues)
                    self.issueViewDataSource.reload(count: issues.count)
                    
                } else {
                    print("Error")
                }
            }
        }
    }


    func sendNewIssue( issue: Issue ) {
        // Correct url and username/password
        
        if let json = issue.toJSON() {
            let data = HTTPSConnection.convertStringToDictionary(text: json)
            
            let apiEndpoint = "http://0.0.0.0:8181/"
            
            print("sendRawTimetable")
            let networkURL = apiEndpoint + "tracker/Issue"
            let dic = data
            HTTPSConnection.httpRequest(params: dic!, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
                // Move to the UI thread
                
                DispatchQueue.main.async {
                    if (succeeded) {
                        print("Succeeded")
                        //self.config = HTTPSConnection.parseJSONConfig(data: data)
                        
                        
                        //                    if let json = self.config!.toJSONObjects() {
                        //                        print(json)
                        //                        self.sendRemoteConfigFiles(json: json)
                        //                    }
                        
                        //self.reloadAllData()
                        
                    } else {
                        print("Error")
                    }
                }
            }
        }
    }
    
}

extension IssueViewControlleer: ReturnDelegate {
    
    func sendBackData( data: Any ) {
        
        //self.config?.colors[0] = (data as! RCColor)
        //self.reloadAllData()
        
    }
    
}
