//
//  PublishLanguage.swift
//  Dashboard
//
//  Created by Timothy Barnard on 04/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class PublishLanguage: NSViewController, NSWindowDelegate {
    
    var appName = ""
    var appKey = ""
    var appVersion = ""
    var languageID = ""
    var languageName = ""
    var objectVersionID = ""
    var langVersion = ""
    
    var translationList = [String:String]()
    
    @IBOutlet weak var publishedButton: NSButton!
    @IBOutlet weak var appNameTextField: NSTextField!
    @IBOutlet weak var appVersionTextField: NSTextField!
    @IBOutlet weak var langNameTextField: NSTextField!
    @IBOutlet weak var langVersionTextField: NSTextField!
    
    var delegate: ReturnDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.publishedButton.state = 0
        self.view.window?.delegate = self
    }
    
    override func viewWillAppear() {
        self.appVersionTextField.stringValue = appVersion
        self.appNameTextField.stringValue = appName
        self.langNameTextField.stringValue = languageName
        self.langVersionTextField.stringValue = langVersion
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
        
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        self.sendConfigFiles()
    }
    
    func sendConfigFiles() {
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let releaseDate = formatter.string(from: Date())
        
        //self.currentVersion = self.appVersions.stringValue
        
        var translationVersion = LanguageVersion()
        translationVersion.published = "\(self.publishedButton.state)"
        translationVersion.appVersion = self.appVersion
        translationVersion.date = releaseDate
        translationVersion.filePath = "Languages/" + self.appName + "/" + self.languageName + "/" + self.appVersion + ".json"
        translationVersion.languageName = self.languageName
        translationVersion.langVersion = self.langVersionTextField.stringValue
        translationVersion.languageID = self.languageID

        translationVersion.sendInBackground(self.objectVersionID, appKey: self.appKey) { (succeded, data) in
            DispatchQueue.main.async {
                if (succeded) {
                    print("success")
                } else {
                    print("error")
                }
            }
        }

        translationList["filePath"] = translationVersion.filePath
        
        HTTPSConnection.httpPostRequest(params: translationList, endPoint: "translation", appKey: self.appKey) { ( sent, message) in
                
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
