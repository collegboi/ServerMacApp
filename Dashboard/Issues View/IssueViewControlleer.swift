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
    
    @IBOutlet weak var comboBoxVersion: NSComboBox!
    @IBOutlet weak var comboBoxApp: NSComboBox!
    
    fileprivate var appNameDelegate: AppNameDelegate!
    fileprivate var appNameDataSource: AppNameDataSource!
    
    fileprivate var appVersionDelegate: AppVersionDelegate!
    fileprivate var appVersionDataSource: AppNameDataSource!
    
    fileprivate var issueViewDelegate: IssueViewDelegate!
    fileprivate var issueViewDataSource: IssueViewDataSource!
    
    @IBOutlet weak var newIssueButton: NSButton!

    var appKey: String = ""
    var applicationID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newIssueButton.isEnabled = false
        self.getAllApps()
        
        appNameDataSource = AppNameDataSource(comboxBox: comboBoxApp)
        appNameDelegate = AppNameDelegate(comboxBox: comboBoxApp, selectionBlock: { ( row, app) in
            self.appKey = app.appKey
            self.applicationID = (app.objectID?.objectID)!
            self.comboBoxVersion.removeAllItems()
            //self.comboBoxVersion.reloadData()
            self.getAllAppsVersions((app.objectID?.objectID)!)
        })
        
        appVersionDataSource = AppNameDataSource(comboxBox: comboBoxVersion)
        appVersionDelegate = AppVersionDelegate(comboxBox: comboBoxVersion, selectionBlock: { ( row, version) in
            self.newIssueButton.isEnabled = true
            self.getAllIssues()
        })
        
        
        issueViewDataSource = IssueViewDataSource(tableView: issuesTableView)
        issueViewDelegate = IssueViewDelegate(tableView: issuesTableView) { issue in
            self.editIssue(issue: issue)
        }
    }
    
    
    func getAllAppsVersions(_ appID: String) {
        
        var allVersions = [TBAppVersion]()
        
        allVersions.getFilteredInBackground(ofType: TBAppVersion.self, query: ["applicationID":appID as AnyObject]) { (retrieved, versions ) in
            
            DispatchQueue.main.async {
                
                if retrieved {
                    allVersions = versions
                    
                    for version in versions {
                        self.comboBoxVersion.addItem(withObjectValue: version.version)
                    }
                    
                    self.appVersionDelegate.reload(versions)
                    self.appVersionDataSource.reload(versions.count)
                }
            }
        }
    }
    
    
    func getAllApps() {
        
        var allApps = [TBApplication]()
        
        allApps.getAllInBackground(ofType: TBApplication.self) { (retrieved, apps) in
            DispatchQueue.main.async {
                if retrieved {
                    allApps = apps
                    
                    for app in apps {
                        self.comboBoxApp.addItem(withObjectValue: app.name)
                    }
                    
                    self.appNameDelegate.reload(apps)
                    self.appNameDataSource.reload(apps.count)
                }
            }
        }
    }

    
    
    @IBAction func newIssueButton(_ sender: Any) {
        
        let newIssue = Issue(name: "", status: "", type: "", assignee: "", timeSpent: "",  priority: "", version: "")
        self.editIssue(issue: newIssue)
    }
    
    func editIssue(issue: Issue) {
            
        let storyboard = NSStoryboard(name: "EditTickets", bundle: nil)
        let editIssueWindowController = storyboard.instantiateController(withIdentifier: "EditIssue") as! NSWindowController
            
        if let editIssueWindow = editIssueWindowController.window {
                
            let editIssueViewController = editIssueWindow.contentViewController as! EditIssueViewController
            editIssueViewController.issue = issue
            editIssueViewController.appKey = self.appKey
            editIssueViewController.delegate = self
            editIssueViewController.version = self.comboBoxVersion.stringValue
                
            let application = NSApplication.shared()
            application.runModal(for: editIssueWindow)
        }
    }
    
    func getAllIssues() {
        
        var allIssues = [Issue]()
        allIssues.getAllInBackground(ofType: Issue.self, appKey: self.appKey) { (got, issues) in
            
            DispatchQueue.main.async {
                if got {
                    allIssues = issues
                    self.issueViewDelegate.reload(issues)
                    self.issueViewDataSource.reload(count: issues.count)
                }
            }
        }
        
//        print("sendRawTimetable")
//        let networkURL = "/tracker/Issue"
//        let dic = [String:AnyObject]()
//        HTTPSConnection.httpGetRequest(params: dic, url: networkURL) { (succeeded: Bool, data: NSData) -> () in
//            // Move to the UI thread
//            
//            DispatchQueue.main.async {
//                if (succeeded) {
//                    print("Succeeded")
//                    let issues = IssueJSON.parseJSONConfig(data: data as Data)
//                    
//                    self.issueViewDelegate.reload(issues)
//                    self.issueViewDataSource.reload(count: issues.count)
//                    
//                } else {
//                    print("Error")
//                }
//            }
//        }
    }


    func sendNewIssue( issue: Issue ) {
        // Correct url and username/password
        
        issue.sendInBackground(issue.issueID.objectID, appKey: self.appKey) { (sent, data) in
            DispatchQueue.main.async {
                if sent {
                    print("sent")
                }
            }
        }
        
//        if let json = issue.toJSON() {
//            let data = HTTPSConnection.convertStringToDictionary(text: json)
//
//            print("sendRawTimetable")
//            let networkURL =  "/tracker/Issue"
//            let dic = data
//            HTTPSConnection.httpRequest(params: dic!, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
//                // Move to the UI thread
//                
//                DispatchQueue.main.async {
//                    if (succeeded) {
//                        print("Succeeded")
//                        //self.config = HTTPSConnection.parseJSONConfig(data: data)
//                        
//                        
//                        //                    if let json = self.config!.toJSONObjects() {
//                        //                        print(json)
//                        //                        self.sendRemoteConfigFiles(json: json)
//                        //                    }
//                        
//                        //self.reloadAllData()
//                        
//                    } else {
//                        print("Error")
//                    }
//                }
//            }
//        }
    }
    
}

extension IssueViewControlleer: ReturnDelegate {
    
    func sendBackData( data: Any ) {
        
        //self.config?.colors[0] = (data as! RCColor)
        //self.reloadAllData()
        
    }
    
}
