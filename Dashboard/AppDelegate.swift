//
//  AppDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 20/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
//        let storyboard = NSStoryboard(name: "Main", bundle: nil)
//        let editIssueWindowController = storyboard.instantiateController(withIdentifier: "LoginWindow") as! NSWindowController
//        
//        if let editIssueWindow = editIssueWindowController.window {
//            
//            //let editIssueViewController = editIssueWindow.contentViewController as! EditIssueViewController
//            
//            let application = NSApplication.shared()
//            application.runModal(for: editIssueWindow)
//        }
        
//        let storyboard = NSStoryboard(name: "Main", bundle: nil)
//        guard let mainWC = storyboard.instantiateController(withIdentifier: "MainLoginWindow") as? NSWindowController else {
//            fatalError("Error getting main window controller")
//        }
//        // optionally store the reference here
//        //self.mainWindowController = mainWC
//        
//        mainWC.showWindow(self) // or use `.showWindow(self)`
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

