//
//  BackupViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 18/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class BackupViewController: NSViewController {

    
    @IBOutlet weak var doBackups: NSButton!
    @IBOutlet weak var comboxBoxDate: NSComboBox!
    @IBOutlet weak var timeDatePicker: NSDatePicker!
    
    @IBOutlet weak var localButton: NSButton!
    @IBOutlet weak var remoteButton: NSButton!
    
    @IBOutlet weak var pathTextField: NSTextField!
    @IBOutlet weak var hostnameTextField: NSTextField!
    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    
    @IBOutlet weak var backupOutLineView: NSOutlineView!
    
    fileprivate var backupDataSource: BackupDataSource!
    fileprivate var backupDelegate: BackupDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timeDatePicker.dateValue = Date()
        
        self.backupDataSource = BackupDataSource(outlineView: backupOutLineView)
        self.backupDelegate = BackupDelegate(outlineView: backupOutLineView)
        
        self.getAllBackups()
        self.getBackupSettings()
        
        self.localButton.state = 0
        self.remoteButton.state = 0
        self.doBackups.state = 0
    }
    
    func getBackupSettings() {
        
        var backupSettings = [TBBackupSetting]()
        
        backupSettings.getAllInBackground(ofType: TBBackupSetting.self) { (complete, backupsettings) in
            
            DispatchQueue.main.async {
                if complete {
                    
                    backupSettings = backupsettings
                    
                    if backupsettings.count > 0 {
                        
                        let backupSetting = backupsettings[backupsettings.count-1]
                        
                        self.comboxBoxDate.stringValue = backupSetting.schedule
                        self.timeDatePicker.stringValue = backupSetting.time
                        self.pathTextField.stringValue = backupSetting.path
                        self.hostnameTextField.stringValue = backupSetting.hostname
                        self.usernameTextField.stringValue = backupSetting.username
                        self.passwordTextField.stringValue = backupSetting.password
                        
                        switch backupSetting.doBackups {
                        case "1":
                            self.doBackups.state = 1
                        default:
                            self.doBackups.state = 0
                        }
                        
                        switch backupSetting.type {
                            case "1":
                                self.remoteButton.state = 1
                        default:
                            self.localButton.state = 1
                        }
                    }
                }
            }
        }
    }
    
    private var dateFormatter : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone =  TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }

    
    @IBAction func saveBackupSettings(_ sender: Any) {
        
        var type = "0"
        
        if self.localButton.state == 1 {
            type = "0"
        }
        
        if self.remoteButton.state == 1 {
            type = "1"
        }
        
        let backupTime = self.timeDatePicker.dateValue
        var tomorrow = backupTime
        
        let now = Date()
        
        if backupTime < now {
            tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: backupTime, wrappingComponents: false)!
        }
        
        let backupTimStr = self.dateFormatter.string(from: tomorrow)
        
        let backupSettings = TBBackupSetting(hostname: self.hostnameTextField.stringValue,
                                           username: self.usernameTextField.stringValue,
                                           password: self.passwordTextField.stringValue,
                                           time: backupTimStr,
                                           schedule: self.comboxBoxDate.stringValue,
                                           path: self.pathTextField.stringValue,
                                           doBackups: "\(self.doBackups.state)",
                                            type: type )
        
        backupSettings.sendInBackground("") { ( complete, data) in
            DispatchQueue.main.async {
                if complete {
                    print("sent")
                }
            }
        }
        
    }
    
    
    @IBAction func doBackups(_ sender: Any) {
        self.comboxBoxDate.isEnabled = self.doBackups.state == 1
        self.timeDatePicker.isEnabled = self.doBackups.state == 1
        self.localButton.isEnabled = self.doBackups.state == 1
        self.remoteButton.isEnabled = self.doBackups.state == 1
        self.pathTextField.isEnabled = self.doBackups.state == 1
        self.hostnameTextField.isEnabled = self.doBackups.state == 1
        self.usernameTextField.isEnabled = self.doBackups.state == 1
        self.passwordTextField.isEnabled = self.doBackups.state == 1
        self.backupOutLineView.isEnabled = self.doBackups.state == 1
        
    }
    @IBAction func localButton(_ sender: Any) {
        self.remoteButton.state = 0
    }
    @IBAction func remoteButton(_ sender: Any) {
        self.localButton.state = 0
    }
    
    func getAllBackups() {
        
        var allBackups = [TBBackups]()
        
        allBackups.getAllInBackground(ofType: TBBackups.self) { ( retrieved,  backups ) in
            
            DispatchQueue.main.async {
                if retrieved {
                    
                    allBackups = backups
                    
                    self.backupDataSource.reload(backups: backups)

                }
            }
            
        }
    }
}
