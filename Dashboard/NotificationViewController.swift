//
//  NotificationViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 07/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class NotificationViewController: NSViewController {

    fileprivate var notificationViewDelegate: NotifcationViewDelegate!
    fileprivate var notificationViewDataSource: GenericDataSource!
    
    @IBOutlet weak var notificationTableView: NSTableView!
    
    var allNotifications = [TBNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationViewDataSource = GenericDataSource(tableView: notificationTableView)
        notificationViewDelegate = NotifcationViewDelegate(tableView: notificationTableView) { notifcation in
            
        }
        self.getAllNotifications()
    }
    
    
    func reloadTable() {
        self.notificationViewDelegate.reload(self.allNotifications)
        self.notificationViewDataSource.reload(count: self.allNotifications.count)
    }
    
    func getAllNotifications() {
        
        allNotifications.getAllNotifications { (completed, notifications) in
            
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
    
    @IBAction func configureNotifcation(_ sender: Any) {
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
            //sendNotificationView.notifcation = notifcation
            
            let application = NSApplication.shared()
            application.runModal(for: notificationWindow)
        }
    }

    
}

extension NotificationViewController: ReturnDelegate {
    
    func sendBackData( data: Any ) {
        
        if let newNotification = data as? TBNotification {
            self.allNotifications.append(newNotification)
            self.reloadTable()
        }
    }
    
}
