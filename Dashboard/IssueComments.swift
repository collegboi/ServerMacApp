//
//  IssueComments.swift
//  Dashboard
//
//  Created by Timothy Barnard on 28/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class IssueComments: NSView {
    
    
    var commentDate: NSTextField!
    var commentUser: NSTextField!
    var commentsView: NSTextView!
    var commentButton: NSButton!
    
    var drawn: Bool = false
    
    static let height = 200
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func drawView( last: Bool, issueID: String ) {
        if !drawn {
            self.drawn = true
            if last {
                self.setupView("Comment")
            } else {
                self.setupView("Update")
            }
        }
    }
    
    func setupView(_ comment: String) {
        
        self.setBackgroundColor(NSColor.white)
        
        self.layer?.cornerRadius = 10
        
        commentDate = NSTextField(frame: NSRect(x: 10, y: 20 , width: 100, height: 30))
        commentDate.stringValue = "12/1/2017"
        self.addSubview(commentDate)
        
        commentUser = NSTextField(frame: NSRect(x: 10, y: IssueComments.height / 2 , width: 100, height: 30))
        commentUser.stringValue = "Timothy"
        self.addSubview(commentUser)
        
        commentsView = NSTextView(frame: NSRect(x: 120, y: 50, width: Int(self.frame.width - 150), height: IssueComments.height - 70))
        commentsView.string = "Comments added about this issue"
        commentsView.textColor = NSColor.white
        commentsView.setBackgroundColor(NSColor.lightGray)
        self.addSubview(commentsView)
        
        commentButton = NSButton(frame: NSRect(x: self.frame.width - 120, y: 10, width: 70, height: 30))
        commentButton.isBordered = false
        commentButton.setBackgroundColor(NSColor.green)
        commentButton.action = #selector(sendComment)
        commentButton.alignment = .center
        commentButton.attributedTitle = NSAttributedString(string: comment, attributes: [ NSForegroundColorAttributeName : NSColor.white ])
        self.addSubview(commentButton)
        
    }
    
    func sendComment() {
        
        
    }
    
}
