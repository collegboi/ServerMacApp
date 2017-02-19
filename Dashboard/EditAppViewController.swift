//
//  EditAppViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class EditAppViewController: NSViewController, NSWindowDelegate {

    @IBOutlet weak var appViewLabel: NSTextField!
    @IBOutlet weak var appName: NSTextField!
    @IBOutlet weak var appKey: NSTextField!
    @IBOutlet weak var appID: NSTextField!
    @IBOutlet weak var comboBoxAppType: NSComboBox!
    @IBOutlet weak var databaseName: NSTextField!
    
    @IBOutlet weak var appVersionTableView: NSTableView!
    
    fileprivate var appVersionDelegate: VersionViewDelegate!
    fileprivate var appVersionDataSource: AppViewDataSource!
    
    var application: TBApplication?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
        
    }
    
    @IBAction func createNewVersionButton(_ sender: Any) {
        
        let storyboard = NSStoryboard(name: "Settings", bundle: nil)
        let appWindowController = storyboard.instantiateController(withIdentifier: "AppVersion") as! NSWindowController
        
        if let appWindow = appWindowController.window {
            
            let editAppVersionViewController = appWindow.contentViewController as! AppVersionViewController
            editAppVersionViewController.appplicationID = self.application?.objectID?.objectID
            
            let application = NSApplication.shared()
            application.runModal(for: appWindow)
        }

    }
    
    func showAppVersionWindow(_ appVersion: TBAppVersion ) {
        
        let storyboard = NSStoryboard(name: "Settings", bundle: nil)
        let appWindowController = storyboard.instantiateController(withIdentifier: "AppVersion") as! NSWindowController
        
        if let appWindow = appWindowController.window {
            
            let editAppVersionViewController = appWindow.contentViewController as! AppVersionViewController
            editAppVersionViewController.appplicationID = self.application?.objectID?.objectID
            editAppVersionViewController.appVersion = appVersion
            
            let application = NSApplication.shared()
            application.runModal(for: appWindow)
        }
    }
    
    override func viewDidAppear() {
        
        self.view.window?.delegate = self
        
        appVersionDelegate = VersionViewDelegate(tableView: appVersionTableView ) { version in
            self.showAppVersionWindow(version)
        }
        appVersionDataSource = AppViewDataSource(tableView: appVersionTableView)
        
        if application == nil {
            self.appViewLabel.stringValue = "New Application"
            self.appKey.stringValue = UniqueSting.myNewUUID()
        } else {
            self.getVersionsData(self.application!.objectID!.objectID)
            self.appViewLabel.stringValue = "Edit Application"
            
            self.appName.stringValue = self.application!.name
            self.databaseName.stringValue = self.application!.databaseName
            self.appID.stringValue = self.application!.apID
            self.appKey.stringValue = self.application!.appKey
            self.comboBoxAppType.stringValue = self.application!.appType.rawValue
            
        }
    }
    
    func getVersionsData(_ appID : String ) {
        
        var allVersions = [TBAppVersion]()
        
        allVersions.getFilteredInBackground(ofType: TBAppVersion.self, query: ["applicationID":appID as AnyObject]) { (retrieved, versions ) in
            
            DispatchQueue.main.async {
                
                if retrieved {
                    allVersions = versions
                    self.appVersionDelegate.reload(versions)
                    self.appVersionDataSource.reload(count: versions.count)
                }
            }
            
        }
        
    }
    
    @IBAction func appSendButton(_ sender: Any) {
        
        if application == nil {
            
            application = TBApplication(name: self.appName.stringValue,
                                        databaseName: self.databaseName.stringValue,
                                        apID: self.appID.stringValue,
                                        appKey: self.appKey.stringValue,
                                        appType: self.comboBoxAppType.stringValue)
        } else {
            
            self.application?.name = self.appName.stringValue
            self.application?.databaseName = self.databaseName.stringValue
            self.application?.apID = self.appID.stringValue
            self.application?.appKey = self.appKey.stringValue
            self.application?.setApptype( self.comboBoxAppType.stringValue )
        }
        
        application?.sendInBackground((self.application?.objectID?.objectID)!, postCompleted: { (sent, data) in
            
            DispatchQueue.main.async {
                if sent {
                    print("Sent")
                    self.view.window?.close()
                    let application = NSApplication.shared()
                    application.stopModal()
                }
            }
            
        })
        
    }
    
    @IBAction func appCancelButton(_ sender: Any) {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    
}
