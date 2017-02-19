//
//  SettingsViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 08/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {

    @IBOutlet weak var keyFilePathLabel: NSTextField!
    
    @IBOutlet weak var appIDTextField: NSTextField!
    @IBOutlet weak var teamIDTextField: NSTextField!
    @IBOutlet weak var keyIDTextField: NSTextField!
    
    @IBOutlet weak var appTableView: NSTableView!
    
    
    fileprivate var appViewDelegate: AppViewDelegate!
    fileprivate var appViewDataSource: AppViewDataSource!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appViewDataSource = AppViewDataSource(tableView: appTableView)
        appViewDelegate = AppViewDelegate(tableView: appTableView) { app in
            self.showAppView(app)
        }
        
        self.getFileNames()
        self.getAllApplications()
    }
    
    func getAllApplications() {
        
        var allApplications = [TBApplication]()
        
        allApplications.getAllInBackground(ofType:TBApplication.self) { (succeeded: Bool, data: [TBApplication]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    allApplications = data
                    print("scucess")
                    
                    self.appViewDelegate.reload(allApplications)
                    self.appViewDataSource.reload(count: allApplications.count)
                    
                } else {
                    print("error")
                }
            }
        }
    }
    
    
    func getFileNames() {

        var allFiles = [NotificationSetting]()
        
        allFiles.getFilteredInBackground(ofType: NotificationSetting.self, query: [:]) { ( completed, files) in
            
            DispatchQueue.main.async {
                if completed {
                    allFiles = files
                    
                    if files.count > 0 {
                        self.keyFilePathLabel.stringValue = files[0].path
                        self.appIDTextField.stringValue = files[0].appID
                        self.teamIDTextField.stringValue = files[0].teamID
                        self.keyIDTextField.stringValue = files[0].keyID
                    }
                }
            }
        }
    }
    
    @IBAction func createNewApp(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Settings", bundle: nil)
        let appWindowController = storyboard.instantiateController(withIdentifier: "ViewApp") as! NSWindowController
        
        if let appWindow = appWindowController.window {
            let application = NSApplication.shared()
            application.runModal(for: appWindow)
        }

    }
    
    func showAppView(_ application: TBApplication ) {
        
        
        let storyboard = NSStoryboard(name: "Settings", bundle: nil)
        let appWindowController = storyboard.instantiateController(withIdentifier: "ViewApp") as! NSWindowController
        
        if let appWindow = appWindowController.window {
            
            let editAppViewController = appWindow.contentViewController as! EditAppViewController
            editAppViewController.application = application
            
            let application = NSApplication.shared()
            application.runModal(for: appWindow)
        }

    }
    
    
    
    @IBAction func selectKeyFile(_ sender: Any) {
        
        let keyFilePath = selectFileDialog("p8")
        
        if keyFilePath != "" {
            self.keyFilePathLabel.stringValue = keyFilePath
        }
    }

    
    func selectFileDialog(_ fileType: String ) -> String {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a "+fileType+" file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = [fileType];
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url
            
            if (result != nil) {
                let path = result!.path
                return path
            }
        } else {
            return ""
        }
        
        return ""
    }
    
    @IBAction func sendNotificaitonDetails(_ sender: Any) {
        
        let path = self.keyFilePathLabel.stringValue
        let name = "APNSAuthenKey_" + self.keyIDTextField.stringValue + ".p8"
        
        self.sendFile(path, name: name)
        
        let notifcationSetting = NotificationSetting(name: name, path: "Notifications/" + name,
                                                     keyID: self.keyIDTextField.stringValue,
                                                     appID: self.appIDTextField.stringValue,
                                                     teamID: self.teamIDTextField.stringValue)
        
        
        notifcationSetting.sendInBackground("") { (sent, data) in
            DispatchQueue.main.async {
                if sent {
                    print("sent")
                }
            }
        }
    }
    
    func sendFile(_ filePath: String, name: String ) {
        
        HTTPSConnection.httpPostFileRequest(path: filePath, endPoint: "/upload/Notifications/", name: name ) { ( sent, message) in
            
            DispatchQueue.main.async {
                print(message)
            }
        }
        
    }
}
