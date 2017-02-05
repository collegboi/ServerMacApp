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
    
    fileprivate var languagesDelegate: LanguagesDelegate!
    fileprivate var languageDataSource: GenericDataSource!
    
    fileprivate var translkeysDelegate: TranslationKeysDelegate!
    fileprivate var translKeysDataSource: GenericDataSource!
    
    fileprivate var translationViewDelegate: TranslationViewDelegate!
    fileprivate var translationViewDataSource: GenericDataSource!
    
    var translationList: [String:String]?
    var keyList: [String:String]?
    var currentLanguage: String?
    var currentVersion:String?
    var allLanguages: [Languages]?
    var currentLanguageNo: Int = 0
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
            self.currentLanguage = language.name
            self.getTranslation(filePath: language.filePath)
        }
        
        translKeysDataSource = GenericDataSource(tableView: translationKeysTableView)
        translkeysDelegate = TranslationKeysDelegate(tableView: translationKeysTableView) { row, key in
            //self.editIssue(issue: issue)
        }
        
        translationViewDataSource = GenericDataSource(tableView: translationTableView)
        translationViewDelegate = TranslationViewDelegate(tableView: translationTableView) { row, value in
            
        }
        self.getAllLanguages()
    }
    
    
    @IBAction func publishLanguage(_ sender: Any) {
     
        var myList = [String:AnyObject]()
        
        self.allLanguages?[currentLanguageNo].version = self.currentVersion
        self.allLanguages?[currentLanguageNo].filePath = self.currentLanguage! + "/" + self.currentVersion! + ".json"
        
        myList["translationList"] = self.translationList as AnyObject
        myList["language"] = self.allLanguages?[currentLanguageNo].toJSONObjects() as AnyObject
        myList["newVersion"] = self.allLanguages![currentLanguageNo].name + "/" + self.currentVersion! + ".json" as AnyObject
        
        self.sendInBackground(myList) { (succeeded, data) in
            DispatchQueue.main.async {
                if (succeeded) {
                    print("success")
                } else {
                    print("error")
                }
            }
        }
        
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
    
    func getAllLanguages() {
        
        self.allLanguages = [Languages]()
        self.allLanguages?.getAllInBackground(ofType:Languages.self) { (succeeded: Bool, data: [Languages]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    self.allLanguages = data
                    
                    self.languageDataSource.reload(count: data.count)
                    self.languagesDelegate.reload(languages: data)
                    
                    print("success")
                } else {
                    print("error")
                }
            }
        }
    }
    
    func getTranslation( filePath: String ) {
        
        let filePathStr = "/"+filePath
        
        self.getTranslationFile(filePath: filePathStr) { (succeeded: Bool, data: [String:String]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    
                    if !self.firstLoad {
                        self.keyList = data
                        self.translKeysDataSource.reload(count: data.count)
                        self.translkeysDelegate.reload(keys: data)
                    }
                    self.firstLoad = true
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

extension TranslationViewController: NSComboBoxDataSource,NSComboBoxDelegate {
    
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        guard let comboBox = notification.object as? NSComboBox else {
            return
        }
        
        print("comboBox objectValueOfSelectedItem: \(comboBox.objectValueOfSelectedItem)")
        /* This printed the correct selected String value */
        
        print("comboBox indexOfSelectedItem: \(comboBox.indexOfSelectedItem)")
        
        let version = "\(comboBox.objectValueOfSelectedItem!)"
        
        self.currentLanguage = self.allLanguages?[self.currentLanguageNo].name ?? "English"
        self.currentVersion = version
        
        let filePath = self.currentLanguage! + "/" + self.currentVersion! + ".json"
        
        self.getTranslation(filePath: filePath)
    }
}

extension TranslationViewController: ReturnDelegate {
    
    //Returning from PublishLanguage
    func sendBackData( data: Any ) {
        
//        if let languages = data as? [Languages] {
//            
//            for language in languages {
//                
//                //let newData
//                
//            }
//            
//        }
        
    }
    
}
