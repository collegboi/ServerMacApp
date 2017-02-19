//
//  AppVersionViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class AppVersionViewController: NSViewController, NSWindowDelegate {

    
    @IBOutlet weak var appVersionLabel: NSTextField!
    @IBOutlet weak var appVersionNo: NSTextField!
    @IBOutlet weak var appVersionDate: NSDatePicker!
    @IBOutlet weak var releaseNotes: NSTextView!
    
    var appVersion: TBAppVersion?
    var appplicationID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
    }
    
    
    override func viewDidAppear() {
        
        self.view.window?.delegate = self
        
        if appVersion != nil {
            
            self.appVersionLabel.stringValue = "Edit Version"
            self.appVersionNo.stringValue = appVersion!.version
            self.releaseNotes.string = appVersion!.notes
        } else {
            self.appVersionLabel.stringValue = "New Version"
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        if appVersion == nil {
            appVersion = TBAppVersion(applicationID: appplicationID!,
                                      version: self.appVersionNo.stringValue,
                                      date: self.appVersionDate.stringValue,
                                      notes: self.releaseNotes.string!)
        }
        
        
        appVersion?.sendInBackground((self.appVersion?.objectID?.objectID)!, postCompleted: { (sent, data) in
            
            DispatchQueue.main.async {
                if sent {
                    print("Verison sent")
                    self.view.window?.close()
                    let application = NSApplication.shared()
                    application.stopModal()
                }
            }
        })
    }
}
