//
//  EditIssueViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 28/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class EditIssueViewController: NSViewController {

    var allCommentsView = [NSView]()
    
    @IBOutlet weak var issueName: NSTextField!
    @IBOutlet weak var assigneee: NSTextField!
    
    @IBOutlet weak var typeMenu: NSPopUpButton!
    @IBOutlet weak var priorityMenu: NSPopUpButton!
    @IBOutlet weak var statusMenu: NSPopUpButton!
    @IBOutlet weak var versionMenu: NSPopUpButton!
    
    @IBOutlet weak var commentsScrollView: NSScrollView!
    
    var containerView: NSView!
    
    var delegate: ReturnDelegate?
    
    var issue: Issue?
    
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
        
        self.versionMenu.removeAllItems()
        self.versionMenu.addItem(withTitle: "1.2.2")
        self.versionMenu.addItem(withTitle: "1.3")
        
        
        let comment1 = IssueComments(frame: NSRect(x: 10, y: 0, width: self.commentsScrollView.frame.width - 20, height: 200))
        comment1.drawView(last: false, issueID: "122")
        let comment2 = IssueComments(frame: NSRect(x: 10, y: 200, width: self.commentsScrollView.frame.width - 20, height: 200))
        comment2.drawView(last: false, issueID: "122")
        let comment3 = IssueComments(frame: NSRect(x: 10, y: 300, width: self.commentsScrollView.frame.width - 20, height: 200))
        comment3.drawView(last: false, issueID: "122")
        let comment4 = IssueComments(frame: NSRect(x: 10, y: 400, width: self.commentsScrollView.frame.width - 20, height: 200))
        comment4.drawView(last: true, issueID: "122")
        
        self.allCommentsView.append(comment1)
        self.allCommentsView.append(comment2)
        self.allCommentsView.append(comment3)
        self.allCommentsView.append(comment4)//new empty read
        
        var scrollViewContextSize: CGFloat = 0
        var yPosition: CGFloat  = 0
        let commentHeight: CGFloat = 210
        
        for view in allCommentsView {
            
            view.frame.origin.y = yPosition
            
            containerView.addSubview(view)
            
            yPosition += commentHeight
            scrollViewContextSize += commentHeight
            
            self.containerView.frame = NSRect(x: 0, y: 0, width: self.commentsScrollView.frame.width, height: scrollViewContextSize)
            
        }
        
        self.commentsScrollView.documentView = containerView
    }
    
    override func viewDidAppear() {
        
        //self.view.window!.standardWindowButton(NSWindowButton.closeButton)!.isHidden = false
        
        if issue != nil {
            self.issueName.stringValue = issue!.name
            self.assigneee.stringValue = issue!.assingee
        }
    }
    
}
