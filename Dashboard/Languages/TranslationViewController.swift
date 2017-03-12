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
    
    @IBOutlet weak var publishLanguage: NSButton!
    
    @IBOutlet weak var comboBoxLangVersion: NSComboBox!
    @IBOutlet weak var comboBoxVersion: NSComboBox!
    @IBOutlet weak var comboBoxApp: NSComboBox!
    
    fileprivate var appNameDelegate: AppNameDelegate!
    fileprivate var appNameDataSource: AppNameDataSource!
    
    fileprivate var appVersionDelegate: AppVersionDelegate!
    fileprivate var appVersionDataSource: AppNameDataSource!
    
    fileprivate var appLangVersionDelegate: AppLangVersionDelegate!
    fileprivate var appLangVersionDataSource: AppNameDataSource!

    
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
    var activeLanguage = 0
    var currentVersion:String?
    var allLanguages = [Languages]()
    var translationVersion : LanguageVersion?
    
    var currentLanguageNo: Int = -1
    var firstLoad: Bool = false
    
    var versionData = [String]()
    
    var appKey = ""
    var applicationID = ""
    var languageID = ""
    
    override func viewWillAppear() {
        self.getAllApps()
        self.publishLanguage.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.publishLanguage.isEnabled = true
            self.comboBoxLangVersion.removeAllItems()
            
            self.getAllLanguages()
            self.getTranslationKeys()
            
        })
        
        appLangVersionDataSource = AppNameDataSource(comboxBox: comboBoxLangVersion)
        appLangVersionDelegate = AppLangVersionDelegate(comboxBox: comboBoxLangVersion, selectionBlock: { ( row, version) in
            
            self.getTranslation(endPoint: "translationVersion", version: version.langVersion , language: self.currentLanguage ?? "" )
        })

        
        languageDataSource = GenericDataSource(tableView: languageTableView)
        languagesDelegate = LanguagesDelegate(tableView: languageTableView) { row, language in
            self.languageID = language.objectID?.objectID ?? ""
            self.currentLanguageNo = row
            self.currentLanguageLabel.stringValue = language.name
            self.currentLanguage = language.name
            self.activeLanguage = language.available
            self.getTranslation(endPoint: "translation", version: self.comboBoxVersion.stringValue , language: language.name )
        }
        
        translKeysDataSource = GenericDataSource(tableView: translationKeysTableView)
        translkeysDelegate = TranslationKeysDelegate(tableView: translationKeysTableView) { row, key in
            
        }
        
        translationViewDataSource = GenericDataSource(tableView: translationTableView)
        translationViewDelegate = TranslationViewDelegate(tableView: translationTableView) { row, value in
            
        }
    }
    
    func getAllConfigVersions(_ appID: String, _ version: String ) {
        
        var allVersions = [LanguageVersion]()
        
        allVersions.getFilteredInBackground(ofType: LanguageVersion.self, query: ["languageID": appID as AnyObject, "appVersion": version as AnyObject ], appKey: self.appKey ) { (retrieved, versions) in
            
            DispatchQueue.main.async {
                if retrieved {
                    allVersions = versions
                    
                    for version in versions {
                        self.comboBoxLangVersion.addItem(withObjectValue: version.langVersion)
                    }
                    
                    self.appLangVersionDelegate.reload(versions)
                    self.appVersionDataSource.reload(versions.count)
                }
            }
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
        
        allApps.getAllInBackground(ofType: TBApplication.self) { (retrieved, apps) in
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

    
    
    @IBAction func publishLanguage(_ sender: Any) {
        
        let storyboard = NSStoryboard(name: "Languages", bundle: nil)
        let viewExceptionWindowController = storyboard.instantiateController(withIdentifier: "PublishVersion") as! NSWindowController
        
        if let viewExceptionWindow = viewExceptionWindowController.window {
            
            let publishLanguage = viewExceptionWindow.contentViewController as! PublishLanguage
            publishLanguage.appVersion = self.comboBoxVersion.stringValue
            publishLanguage.appName = self.comboBoxApp.stringValue
            publishLanguage.langVersion = self.comboBoxLangVersion.stringValue
            publishLanguage.languageID = self.languageID
            publishLanguage.translationList = self.translationList
            publishLanguage.appKey = self.appKey
            publishLanguage.languageName = self.currentLanguage ?? ""
            publishLanguage.delegate = self
            
            let application = NSApplication.shared()
            application.runModal(for: viewExceptionWindow)
        }

    }
    
    func getTranslationKeys() {
        
        self.allTranslationKeys.getAllInBackground(ofType: TranslationKeys.self, appKey: self.appKey) { (succeeded: Bool, data: [TranslationKeys]) -> () in
            
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
    
        self.allLanguages.getAllInBackground(ofType: Languages.self, appKey: self.appKey ) { (succeeded: Bool, data: [Languages]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    self.allLanguages = data
                    
                    guard let firstLang = self.allLanguages.first, self.allLanguages.count > 0 else {
                        return
                    }
                    self.currentLanguageNo = 0
                    self.currentLanguage = firstLang.name
                    self.currentLanguageLabel.stringValue = firstLang.name
                    self.languageID = firstLang.objectID?.objectID ?? ""
                    
                    self.getAllConfigVersions(firstLang.objectID?.objectID ?? "", self.comboBoxVersion.stringValue )
                    
                    self.getTranslation(endPoint: "translation", version: self.comboBoxVersion.stringValue , language: firstLang.name )
                    
                    
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
    
    func getTranslation(endPoint: String, version: String, language: String) {
        
        self.getTranslationFile(appKey: self.appKey, endPoint: endPoint, version: version, language: language) { (succeeded: Bool, data: [String:String]) -> () in
            
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
        
        var language = Languages()
        language.available = 0
        language.name = ""
        language.removeInBackground(self.languageID) { (deleted, message) in
            DispatchQueue.main.async {
                if deleted {
                    print("message deleted")
                }
            }
        }
    }
    
    func addKey() {
        self.showMessageBox("Add Key", 2)
    }
    
    func addKeyValueToLanguage( ) {
        self.showMessageBoxKeyValue( "Add Translation for " + self.currentLanguage! , 3)
    }
    
    func makeActive() {
        var language = Languages()
        language.available = 1
        language.name = self.currentLanguage ?? ""
        language.sendInBackground(self.languageID, appKey: self.appKey) { (completed, data) in
            DispatchQueue.main.async {
                if completed {
                    print("active")
                    self.activeLanguage = 1
                    self.reloadLanguageTable()
                }
            }
        }
    }
    
    func makeNotActive() {
        
        var language = Languages()
        language.available = 0
        language.name = self.currentLanguage ?? ""
        language.sendInBackground(self.languageID, appKey: self.appKey) { (completed, data) in
            DispatchQueue.main.async {
                if completed {
                    print("not active")
                    self.activeLanguage = 0
                    self.reloadLanguageTable()
                }
            }
        }
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        
        switch menu.title {
            
        case "Language":
            
            if menu.items.count == 1 {
                
                menu.removeAllItems()
                
                menu.addItem(withTitle: "Add", action: #selector(self.addLanguage), keyEquivalent: "")
                
                if self.languageID != "" {
                
                    menu.addItem(withTitle: "Remove", action: #selector(self.removeLanguage), keyEquivalent: "")
                    menu.addItem(withTitle: "", action: nil, keyEquivalent: "")
                    //if self.activeLanguage == 0 {
                        menu.addItem(withTitle: "Active", action: #selector(self.makeActive), keyEquivalent: "")
                    //} else {
                        menu.addItem(withTitle: "Not Active", action: #selector(self.makeNotActive), keyEquivalent: "")
                    //}
                    
                }
            
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


//extension TranslationViewController: NSComboBoxDataSource,NSComboBoxDelegate {
//    
//    
//    func comboBoxSelectionDidChange(_ notification: Notification) {
//        
//        guard let comboBox = notification.object as? NSComboBox else {
//            return
//        }
//        
//        print("comboBox objectValueOfSelectedItem: \(comboBox.objectValueOfSelectedItem)")
//        /* This printed the correct selected String value */
//        
//        print("comboBox indexOfSelectedItem: \(comboBox.indexOfSelectedItem)")
//        
//        let version = "\(comboBox.objectValueOfSelectedItem!)"
//        
//        if currentLanguageNo >= 0 {
//            
//            self.translationList.removeAll()
//            
//            self.currentLanguage = self.allLanguages[self.currentLanguageNo].name ?? "English"
//            self.currentVersion = version
//            
//            let filePath = self.currentLanguage! + "/" + self.currentVersion! + ".json"
//            
//            
//        }
//    }
//}

extension TranslationViewController: ReturnDelegate {
    
    //Returning from PublishLanguage
    func sendBackData( data: Any ) {
        
        if let returnObj = data as? ReturnObject {
            
            switch returnObj.id {
            case 1:
                let newLanguage = Languages(name: returnObj.value, available: 1)
                newLanguage.sendInBackground("", appKey: self.appKey ) { (complete, data) in
                    DispatchQueue.main.async {
                        print("sent")
                        self.currentLanguage = returnObj.value
                        self.allLanguages.append(newLanguage)
                        self.reloadLanguageTable()
                    }
                }
                break
            case 2:
            
                let newkey = TranslationKeys(name: returnObj.value)
                newkey.sendInBackground("", appKey: self.appKey ) { ( complete , data) in
                    DispatchQueue.main.async {
                        if complete {
                            print("sent")
                            self.allTranslationKeys.append(newkey)
                            self.reloadKeysTable()
                        }
                    }
                    
                }
                
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
