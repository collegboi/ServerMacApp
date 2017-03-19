//
//  NotificationViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 07/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class NotificationViewController: NSViewController {

    
    @IBOutlet weak var comboBoxVersion: NSComboBox!
    @IBOutlet weak var comboBoxApp: NSComboBox!
    
    fileprivate var appNameDelegate: AppNameDelegate!
    fileprivate var appNameDataSource: AppNameDataSource!
    
    fileprivate var appVersionDelegate: AppVersionDelegate!
    fileprivate var appVersionDataSource: AppNameDataSource!
    
    fileprivate var notificationViewDelegate: NotifcationViewDelegate!
    fileprivate var notificationViewDataSource: GenericDataSource!
    
    @IBOutlet weak var notificationTableView: NSTableView!
    @IBOutlet weak var sendNotifcaiton: NSButton!
    
    var allNotifications = [TBNotification]()
    var appKey: String = ""
    var applicationID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendNotifcaiton.isEnabled = false
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
            self.sendNotifcaiton.isEnabled = true
            self.getAllNotifications()
        })
        
        notificationViewDataSource = GenericDataSource(tableView: notificationTableView)
        notificationViewDelegate = NotifcationViewDelegate(tableView: notificationTableView) { notifcation in
            
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
        
        allApps.getAllInBackground( ofType: TBApplication.self) { (retrieved, apps) in
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

    
    func reloadTable() {
        self.notificationViewDelegate.reload(self.allNotifications)
        self.notificationViewDataSource.reload(count: self.allNotifications.count)
    }
    
    func getAllNotifications() {
        
        allNotifications.getAllNotifications(self.appKey){ (completed, notifications) in
            
            DispatchQueue.main.async {
                if (completed) {
                    
                    self.allNotifications = notifications
                    self.reloadTable()
                    print("completed")
                } else {
                    print("error")
                }
            }
        }
    }
    
    @IBAction func sendNotifcaiton(_ sender: Any) {
        self.showSendNotifcationWindow()
    }
    
    func sendFile(_ filePath: String) {
        
        HTTPSConnection.httpPostFileRequest(path: filePath, endPoint: "/upload/Images/", name:"Image1") { (sent, message) in
            DispatchQueue.main.async {
                print(message)
            }
        }
    }
    
    func showSendNotifcationWindow() {
        
        let storyboard = NSStoryboard(name: "Notifications", bundle: nil)
        let notificationWindowController = storyboard.instantiateController(withIdentifier: "SendNotification") as! NSWindowController
        
        if let notificationWindow = notificationWindowController.window {
            
            
            let sendNotificationView = notificationWindow.contentViewController as! SendNotificationView
            sendNotificationView.delegate = self
            sendNotificationView.appKey = self.appKey
            
            let application = NSApplication.shared()
            application.runModal(for: notificationWindow)
        }
    }
}

extension NotificationViewController: ReturnDelegate {
    
    func sendBackData( data: Any ) {
        
        self.getAllNotifications()
//        if let newNotification = data as? TBNotification {
//            self.allNotifications.append(newNotification)
//            self.reloadTable()
//        }
    }
    
}
