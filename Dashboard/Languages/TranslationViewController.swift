//
//  TranslationViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 04/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class TranslationViewController: NSViewController {

    @IBOutlet weak var languageTableView:NSTableView!
    @IBOutlet weak var translationKeysTableView:NSTableView!
    @IBOutlet weak var translationTableView:NSTableView!
    
    @IBOutlet weak var appVersions: NSComboBox!
    
    @IBOutlet weak var currentLanguageLabel: NSTextField!
    
    fileprivate var languagesDelegate: LanguagesDelegate!
    fileprivate var languageDataSource: GenericDataSource!
    
    fileprivate var translkeysDelegate: TranslationKeysDelegate!
    fileprivate var translKeysDataSource: GenericDataSource!
    
    fileprivate var translationViewDelegate: TranslationViewDelegate!
    fileprivate var translationViewDataSource: GenericDataSource!
    
    var translationList = [String:String]()
    var allTranslationKeys = [TranslationKeys]()
    var currentLanguage: String?
    var currentVersion:String?
    var allLanguages = [Languages]()
    var translationVersion : LanguageVersion?
    
    var currentLanguageNo: Int = -1
    var firstLoad: Bool = false
    
    var versionData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionData.append("1.2.1")
        versionData.append("1.3")
        versionData.append("1.5")
        
        self.appVersions.removeAllItems()
        
        self.appVersions.addItem(withObjectValue: "1.2.1")
        self.appVersions.addItem(withObjectValue: "1.3")
        self.appVersions.addItem(withObjectValue: "1.5")
        
        self.appVersions.delegate = self
        self.appVersions.dataSource = self
        
        self.appVersions.reloadData()
        
        self.appVersions.selectItem(at: 0)
        
        languageDataSource = GenericDataSource(tableView: languageTableView)
        languagesDelegate = LanguagesDelegate(tableView: languageTableView) { row, language in
            self.currentLanguageNo = row
            self.currentLanguageLabel.stringValue = language.name
            self.currentLanguage = language.name
            self.getTranslation(filePath: language.name)
        }
        
        translKeysDataSource = GenericDataSource(tableView: translationKeysTableView)
        translkeysDelegate = TranslationKeysDelegate(tableView: translationKeysTableView) { row, key in
            //self.editIssue(issue: issue)
        }
        
        translationViewDataSource = GenericDataSource(tableView: translationTableView)
        translationViewDelegate = TranslationViewDelegate(tableView: translationTableView) { row, value in
            
        }
        self.getAllLanguages()
        self.getTranslationKeys()
    }
    
    
    @IBAction func publishLanguage(_ sender: Any) {
     
        var myList = [String:AnyObject]()
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let releaseDate = formatter.string(from: Date())
        
        self.currentVersion = self.appVersions.stringValue
        
        self.translationVersion = LanguageVersion(langaugeID: "", version: "1.2", filePath: "", name: "", published: "0", date: releaseDate)
        
        self.translationVersion?.version = self.currentVersion
        self.translationVersion?.filePath = self.currentLanguage! + "/" + self.currentVersion! + ".json"
        self.translationVersion?.langaugeID = self.allLanguages[self.currentLanguageNo].objectID?.objectID
        
        myList["translationList"] = self.translationList as AnyObject
        myList["language"] = self.allLanguages[currentLanguageNo].toJSONObjects() as AnyObject
        myList["newVersion"] = self.allLanguages[currentLanguageNo].name + "/" + self.currentVersion! + ".json" as AnyObject
        
        self.sendInBackground(myList) { (succeeded, data) in
            DispatchQueue.main.async {
                if (succeeded) {
                    print("success")
                } else {
                    print("error")
                }
            }
        }
        
        self.translationVersion?.sendInBackground((self.translationVersion?.objectID?.objectID)!, postCompleted: { (sent, data) in
            
            DispatchQueue.main.async {
                if sent {
                    print("semt")
                }
            }
            
        })
        
//        let storyboard = NSStoryboard(name: "Languages", bundle: nil)
//        let viewExceptionWindowController = storyboard.instantiateController(withIdentifier: "PublishVersion") as! NSWindowController
//        
//        if let viewExceptionWindow = viewExceptionWindowController.window {
//            
//            let publishLanguage = viewExceptionWindow.contentViewController as! PublishLanguage
//            publishLanguage.allLanguages = self.allLanguages
//            publishLanguage.publishVersionStr = self.currentVersion
//            publishLanguage.delegate = self
//            
//            let application = NSApplication.shared()
//            application.runModal(for: viewExceptionWindow)
//        }

    }
    
    func getTranslationKeys() {
        
        self.allTranslationKeys.getAllInBackground(ofType: TranslationKeys.self) { (succeeded: Bool, data: [TranslationKeys]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    self.allTranslationKeys = data
                    
                    self.reloadKeysTable()
                    
                    print("success")
                } else {
                    print("error")
                }
            }
        }
    }

    
    
    func getAllLanguages() {
    
        self.allLanguages.getAllInBackground(ofType:Languages.self) { (succeeded: Bool, data: [Languages]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    self.allLanguages = data
                    
                    guard let firstLang = self.allLanguages.first, self.allLanguages.count > 0 else {
                        return
                    }
                    self.currentLanguageNo = 0
                    self.currentLanguage = firstLang.name
                    self.currentLanguageLabel.stringValue = firstLang.name
                    
                    self.reloadLanguageTable()
                    
                    print("success")
                } else {
                    print("error")
                }
            }
        }
    }
    func reloadKeysTable() {
        
        self.translKeysDataSource.reload(count: self.allTranslationKeys.count)
        self.translkeysDelegate.reload(keys: self.allTranslationKeys)
    }
    
    func reloadLanguageTable() {
        
        self.languageDataSource.reload(count: self.allLanguages.count)
        self.languagesDelegate.reload(languages: self.allLanguages)
    }
    
    func reloadTranslationsTable() {
        
        self.translationViewDataSource.reload(count: self.translationList.count)
        self.translationViewDelegate.reload(translations: self.translationList)
    }
    
    func getTranslation( filePath: String ) {
        
        let filePathStr = "/"+filePath
        
        self.getTranslationFile(filePath: filePathStr) { (succeeded: Bool, data: [String:String]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    self.translationList = data
                    self.translationViewDataSource.reload(count: data.count)
                    self.translationViewDelegate.reload(translations: data)
                    
                    print("scucess")
                } else {
                    print("error")
                }
            }
        }
    }
}

extension TranslationViewController: NSMenuDelegate {
    
    func menuWillOpen(_ menu: NSMenu) {
        
    }
    
    func showMessageBox( _ title: String, _ id: Int ) {
        
        let storyboard = NSStoryboard(name: "AlertTextField", bundle: nil)
        let alertTextFieldWindowController = storyboard.instantiateController(withIdentifier: "AlertTextField") as! NSWindowController

        if let alertTextFieldWindow = alertTextFieldWindowController.window {

            let textViewController = alertTextFieldWindow.contentViewController as! TextViewController
            textViewController.returnDelegate = self
            textViewController.labelString = title
            textViewController.id = id

            let application = NSApplication.shared()
            application.runModal(for: alertTextFieldWindow)
        }
        
    }
    func showMessageBoxKeyValue( _ title: String, _ id: Int, _ key: String = "", _ value: String = "" ) {
        
        let storyboard = NSStoryboard(name: "AlertTextField", bundle: nil)
        let alertTextFieldWindowController = storyboard.instantiateController(withIdentifier: "KeyValueWindow") as! NSWindowController
        
        if let alertTextFieldWindow = alertTextFieldWindowController.window {
            
            let textKeyValueController = alertTextFieldWindow.contentViewController as! TextKeyValueController
            textKeyValueController.returnDelegate = self
            textKeyValueController.labelString = title
            textKeyValueController.id = id
            textKeyValueController.value = value
            textKeyValueController.key = key
            
            let application = NSApplication.shared()
            application.runModal(for: alertTextFieldWindow)
        }
        
    }
    
    
    func addLanguage() {
        self.showMessageBox("Add Language", 1)
    }
    
    
    
    @discardableResult
    func dialogOKCancel(message: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = message
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "OK")
        return myPopup.runModal() == NSAlertFirstButtonReturn
    }
    
    
    func removeLanguage() {
      
    }
    
    func addKey() {
        self.showMessageBox("Add Key", 2)
    }
    
    func addKeyValueToLanguage( ) {
        self.showMessageBoxKeyValue( "Add Translation for " + self.currentLanguage! , 3)
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        
        switch menu.title {
            
        case "Language":
            
            if menu.items.count == 1 {
                
                menu.removeAllItems()
                
                menu.addItem(withTitle: "Remove", action: #selector(self.removeLanguage), keyEquivalent: "")
                menu.addItem(withTitle: "Add", action: #selector(self.addLanguage), keyEquivalent: "")
            }
            break
            
        case "Key":
            
            if menu.items.count == 1 {
                
                menu.removeAllItems()
                    
                menu.addItem(withTitle: "Add new key", action: #selector(self.addKey), keyEquivalent: "")
                menu.addItem(withTitle: "Add to " + self.currentLanguage! , action: #selector(self.addKeyValueToLanguage), keyEquivalent: "")
            }
            
            break
        default: break
        }
    }
}


extension TranslationViewController: NSComboBoxDataSource,NSComboBoxDelegate {
    
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        guard let comboBox = notification.object as? NSComboBox else {
            return
        }
        
        print("comboBox objectValueOfSelectedItem: \(comboBox.objectValueOfSelectedItem)")
        /* This printed the correct selected String value */
        
        print("comboBox indexOfSelectedItem: \(comboBox.indexOfSelectedItem)")
        
        let version = "\(comboBox.objectValueOfSelectedItem!)"
        
        if currentLanguageNo >= 0 {
            
            self.translationList.removeAll()
            
            self.currentLanguage = self.allLanguages[self.currentLanguageNo].name ?? "English"
            self.currentVersion = version
            
            let filePath = self.currentLanguage! + "/" + self.currentVersion! + ".json"
            
            self.getTranslation(filePath: filePath)
        }
    }
}

extension TranslationViewController: ReturnDelegate {
    
    //Returning from PublishLanguage
    func sendBackData( data: Any ) {
        
        if let returnObj = data as? ReturnObject {
            
            switch returnObj.id {
            case 1:
                let newLanguage = Languages(name: returnObj.value, available: 1)
                newLanguage.sendInBackground("") { (complete, data) in
                    DispatchQueue.main.async {
                        print("sent")
                        self.allLanguages.append(newLanguage)
                        self.reloadLanguageTable()
                    }
                }
                break
            case 2:
                
                let newkey = TranslationKeys(name: returnObj.value)
                newkey.sendInBackground("", postCompleted: { ( complete , data) in
                    DispatchQueue.main.async {
                        if complete {
                            print("sent")
                            self.allTranslationKeys.append(newkey)
                            self.reloadKeysTable()
                        }
                    }
                    
                })
                
                break
                
            case 3:
                
                self.translationList[returnObj.key] = returnObj.value
                self.reloadTranslationsTable()
                break
                
            default: break
                
            }

        }
        
    }
    
}
