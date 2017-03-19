//
//  EditIssueViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 28/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class EditIssueViewController: NSViewController, NSWindowDelegate {

    var allCommentsView = [NSView]()
    
    @IBOutlet weak var issueName: NSTextField!
    @IBOutlet weak var assigneee: NSTextField!
    
    @IBOutlet weak var typeMenu: NSPopUpButton!
    @IBOutlet weak var priorityMenu: NSPopUpButton!
    @IBOutlet weak var statusMenu: NSPopUpButton!
    @IBOutlet weak var versionLabel: NSTextField!
    
    @IBOutlet weak var commentsScrollView: NSScrollView!
    @IBOutlet weak var saveButton: NSButton!
    
    @IBOutlet weak var viewExceptionButton: NSButton!
    
    
    var containerView: NSView!
    
    var issueActivities = [IssueActivity]()
    
    var delegate: ReturnDelegate?
    
    var issue: Issue?
    var exceptionID: MBOjectID?
    var appKey: String = ""
    var version: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView = NSView()
        containerView.frame = NSRect(x: 0, y: 0, width: self.commentsScrollView.frame.width, height: 0)
        containerView.setBackgroundColor(NSColor.lightGray)
        
        self.typeMenu.removeAllItems()
        self.typeMenu.addItem(withTitle: "Bug")
        self.typeMenu.addItem(withTitle: "Feature")
        self.typeMenu.addItem(withTitle: "Improvement")
        
        self.priorityMenu.removeAllItems()
        self.priorityMenu.addItem(withTitle: "Low")
        self.priorityMenu.addItem(withTitle: "High")
        self.priorityMenu.addItem(withTitle: "Critical")
        self.priorityMenu.addItem(withTitle: "Down")

        self.statusMenu.removeAllItems()
        self.statusMenu.addItem(withTitle: "TODO")
        self.statusMenu.addItem(withTitle: "In Progress")
        self.statusMenu.addItem(withTitle: "Complete")
        self.statusMenu.addItem(withTitle: "On Hold")
        
        self.viewExceptionButton.isEnabled = false
        
        //self.testSever()
        //self.testGetServer()
        
    }
    
    func testGetServer() {
        
        var result = [TestObject]()
        result.getAllInBackground(ofType:TestObject.self) { (succeeded: Bool, data: [TestObject]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    result = data
                    print("scucess")
                } else {
                    print("error")
                }
            }
        }
    }
    
    @IBAction func viewExceptionButton(_ sender: Any) {
        
        let storyboard = NSStoryboard(name: "ViewCrash", bundle: nil)
        let viewExceptionWindowController = storyboard.instantiateController(withIdentifier: "ViewException") as! NSWindowController
        
        if let viewExceptionWindow = viewExceptionWindowController.window {
            
            let viewCrashViewController = viewExceptionWindow.contentViewController as! ViewCrashViewController
            viewCrashViewController.exception = nil
            viewCrashViewController.exceptionID = self.issue!.exceptionID
            //viewCrashViewController.delegate = self
            
            let application = NSApplication.shared()
            application.runModal(for: viewExceptionWindow)
        }
        
    }
    
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
        
    }
    @IBAction func saveButton(_ sender: Any) {
        self.getValuesForIssue()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    func getValuesForIssue() {
        
        issue!.name = self.issueName.stringValue
        issue!.assingee = self.assigneee.stringValue
        
        let sIndex = statusMenu.indexOfSelectedItem
        issue!.status = self.statusMenu.itemTitle(at: sIndex)
        
        let tIndex = typeMenu.indexOfSelectedItem
        issue!.type = self.typeMenu.itemTitle(at: tIndex)
        
        let pIndex = priorityMenu.indexOfSelectedItem
        issue!.prioity = self.priorityMenu.itemTitle(at: pIndex)
        
        issue!.version = self.versionLabel.stringValue
        
        self.sendIssue()
    }
    
    func sendIssue() {
        
        self.issue!.sendInBackground(self.issue!.issueID.objectID, appKey: self.appKey){ (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            DispatchQueue.main.async {
                if (succeeded) {
                    print("scucess")
                } else {
                    print("error")
                }
            }
        }
    }

    
    override func viewDidAppear() {
        
        self.view.window?.delegate = self
        
        self.versionLabel.stringValue = self.version
        
        if issue != nil {
            self.issueName.stringValue = issue!.name
            self.assigneee.stringValue = issue!.assingee
            
            let tIndex = self.typeMenu.item(withTitle: issue!.type)
            self.typeMenu.select(tIndex)
            
            let sIndex = self.statusMenu.item(withTitle: issue!.status)
            self.statusMenu.select(sIndex)
            
            let pIndex = self.priorityMenu.item(withTitle: issue!.prioity)
            self.priorityMenu.select(pIndex)
            
            if self.issue?.exceptionID != ""  {
                self.viewExceptionButton.isEnabled = true
            }
            
        } else {
            issue = Issue()
            issue?.exceptionID = exceptionID?.objectID
        }
        
        if self.issue?.issueID.objectID != "" {
            self.getAllIssuesActivity()
        }

    }
    
    func populateView() {
        
        let emptyActivity = IssueActivity(issueID: issue!.issueID.objectID , issueComments: "Add your comments!", user: "timothy", timeStamp: "28/1/2017 20:30")
        self.issueActivities.append(emptyActivity)
        
        var scrollViewContextSize: CGFloat = 0
        var yPosition: CGFloat  = 0
        let commentHeight: CGFloat = 210
        
        for (index, activity) in self.issueActivities.enumerated() {
            
            let comment1 = IssueComments(frame: NSRect(x: 10, y: index * 100, width: Int(self.commentsScrollView.frame.width - 20), height: 200))
            comment1.appKey = self.appKey
            
            if index == self.issueActivities.count - 1 {
                
                comment1.drawView(last: true, issueID: (issue?.issueID.objectID)!, activity)
            }
            else {
                comment1.drawView(last: false, issueID: (issue?.issueID.objectID)!, activity)
            }
            
            comment1.frame.origin.y = yPosition
            
            containerView.addSubview(comment1)
            
            yPosition += commentHeight
            scrollViewContextSize += commentHeight
            
            self.containerView.frame = NSRect(x: 0, y: 0, width: self.commentsScrollView.frame.width, height: scrollViewContextSize)
        }
        
        self.commentsScrollView.documentView = containerView
    }
    
    func getAllIssuesActivity() {
        
        self.issueActivities.getAllInBackground(ofType: IssueActivity.self, appKey: self.appKey) { (got, allIssueAct) in
            DispatchQueue.main.async {
                if got {
                    self.issueActivities = allIssueAct
                    self.populateView()
                }
            }
        }
        
//        print("sendRawTimetable")
//        let networkURL = "/tracker/IssueActivity/"+self.issue!.issueID.objectID
//        let dic = [String:AnyObject]()
//        HTTPSConnection.httpGetRequest(params: dic, url: networkURL) { (succeeded: Bool, data: NSData) -> () in
//            // Move to the UI thread
//            
//            DispatchQueue.main.async {
//                if (succeeded) {
//                    print("Succeeded")
//                    self.issueActivities = IssueActivityJSON.parseJSONConfig(data: data as Data)
//                    self.populateView()
//                    
//                } else {
//                    print("Error")
//                }
//            }
//        }
    }
    
}
