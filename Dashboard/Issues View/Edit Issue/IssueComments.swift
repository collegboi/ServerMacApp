//
//  IssueComments.swift
//  Dashboard
//
//  Created by Timothy Barnard on 28/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

final class LayoutManager1: NSLayoutManager {
    override func fillBackgroundRectArray(_ rectArray: UnsafePointer<NSRect>, count rectCount: Int, forCharacterRange charRange: NSRange, color: NSColor) {
        let color1 = color == NSColor.selectedTextBackgroundColor ? NSColor.red : color
        color1.setFill()
        super.fillBackgroundRectArray(rectArray, count: rectCount, forCharacterRange: charRange, color: color1)
        color.setFill()
    }
}

class IssueComments: NSView {
    
    
    var commentDate: NSTextField!
    var commentUser: NSTextField!
    var commentsView: NSTextView!
    var commentButton: NSButton!
    
    var drawn: Bool = false
    
    var activity: IssueActivity?
    
    static let height = 200
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func drawView( last: Bool, issueID: String, _ activity: IssueActivity ) {
        self.activity = activity
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
        
        commentUser = NSTextField(frame: NSRect(x: 10, y: IssueComments.height - 50 , width: 100, height: 30))
        commentUser.stringValue = activity!.user
        self.addSubview(commentUser)
        
        commentDate = NSTextField(frame: NSRect(x: 10, y: 50 , width: 100, height: 40))
        commentDate.stringValue = activity!.timeStamp
        self.addSubview(commentDate)
        
        let layoutManager1 = NSLayoutManager()
        let scrollView = NSScrollView()
        scrollView.frame = NSRect(x: 120, y: 50, width: Int(self.frame.width - 150), height: 120)
        
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalScroller = true
        
        scrollView.layer?.borderWidth = 0.5
        scrollView.layer?.cornerRadius = 5
        scrollView.layer?.borderColor = NSColor.black.cgColor
        
        //let textView = NSTextView()
        //textView.frame = CGRect(x: 0, y: 0, width: 300, height: 1000)

        //mainWindow.contentView = scrollView
       //mainWindow.makeKeyAndOrderFront(self)
        //mainWindow.makeFirstResponder(textView)
        
        commentsView = NSTextView(frame: NSRect(x: 120, y: 50, width: Int(self.frame.width - 150), height: 400))
        commentsView.string = activity!.issueComments
        commentsView.textColor = NSColor.black
        //commentsView.setBackgroundColor(NSColor.white)
        //commentsView.layer?.borderWidth = 0.5
        //commentsView.layer?.cornerRadius = 5
        //commentsView.layer?.borderColor = NSColor.black.cgColor
        
        commentsView.textContainer!.replaceLayoutManager(layoutManager1)
        commentsView.isVerticallyResizable = true
        scrollView.documentView = commentsView
        
        
        self.addSubview(scrollView)
        
        let buttonColor = NSColor(colorLiteralRed: 97/255, green: 181/255, blue: 64/100, alpha: 1)
        
        commentButton = NSButton(frame: NSRect(x: self.frame.width - 120, y: 10, width: 70, height: 30))
        commentButton.isBordered = false
        commentButton.setBackgroundColor(buttonColor)
        commentButton.action = #selector(sendComment)
        commentButton.attributedTitle = NSAttributedString(string: comment, attributes: [ NSForegroundColorAttributeName : NSColor.white ])
        commentButton.alignment = .center
        self.addSubview(commentButton)
        
    }
    
    func sendComment() {
        // Correct url and username/password
        
        let issueActivity = IssueActivity(issueID: self.activity!.issueID, issueComments: self.commentsView.string! , user: activity!.user , timeStamp: "28/01/2017 19:42")
        
        if let json = issueActivity.toJSON() {
            let data = HTTPSConnection.convertStringToDictionary(text: json)
            
            let networkURL = "/tracker/IssueActivity"
            let dic = data
            HTTPSConnection.httpRequest(params: dic!, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
                // Move to the UI thread
                
                DispatchQueue.main.async {
                    if (succeeded) {
                        
                    }
                }
            }
        }
    }
}
