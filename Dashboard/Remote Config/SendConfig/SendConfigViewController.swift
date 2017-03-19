//
//  SendConfigViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 09/03/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class SendConfigViewController: NSViewController, NSWindowDelegate {

    @IBOutlet weak var appNameLabel: NSTextField!
    @IBOutlet weak var appVersionLabel: NSTextField!
    @IBOutlet weak var configVersionTextField: NSTextField!
    @IBOutlet weak var appThemeTextField: NSTextField!
    @IBOutlet weak var appConfigLive: NSButton!
    @IBOutlet weak var saveButton: NSButton!
    
    var appName: String {
        get {return self.appName}
        set(name) {
           self.appNameLabel.stringValue = name
        }
    }
    
    var appVersion: String {
        get {return self.appVersion}
        set(value) {
            self.appVersionLabel.stringValue = value
        }
    }
    
    var configVersion: String {
        get {return self.configVersion}
        set(value) {
            if (value) != "" {
                self.saveButton.isEnabled = true
            }
            self.configVersionTextField.stringValue = value
        }
    }
    
    var appTheme: String {
        get {return self.appTheme}
        set(value) {
            self.appThemeTextField.stringValue = value
        }
    }
    
    var config: Config?
    var appKey:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configVersionTextField.delegate = self
        self.view.window?.delegate = self
        self.saveButton.isEnabled = false
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
    }
    
    @IBAction func saveButton(_ sender: Any) {
    
        sendConfigFiles()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    func sendConfigFiles() {
        
        self.config?.version = self.appVersionLabel.stringValue
        self.config?.appTheme = self.appThemeTextField.stringValue
        self.config?.appLive = self.appConfigLive.state
        self.config?.configVersion = self.configVersionTextField.stringValue
        self.config?.filePath = "ConfigFiles/" + self.appNameLabel.stringValue + "/config_" + self.configVersionTextField.stringValue + ".json"
        
        if let data = self.config?.toData() {
            
            HTTPSConnection.httpPostRequest(params: data, endPoint: "/remote", appKey: self.appKey!) { ( sent, message) in
                
                DispatchQueue.main.async {
                    
                    if sent {
                        print("sent")
                        self.view.window?.close()
                        let application = NSApplication.shared()
                        application.stopModal()
                    } else {
                        print("not sent")
                    }
                }
            }
            
        }
    }
}

extension SendConfigViewController: NSTextFieldDelegate {
    
    override func controlTextDidChange(_ obj: Notification) {
        if self.configVersionTextField.stringValue != "" {
            self.saveButton.isEnabled = true
        }else {
            self.saveButton.isEnabled = false
        }
    }
    
}
