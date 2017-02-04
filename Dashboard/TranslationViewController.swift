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
    
    var firstLoad: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appVersions.addItem(withObjectValue: "1.2.1")
        self.appVersions.addItem(withObjectValue: "1.3")
        self.appVersions.addItem(withObjectValue: "1.1")
        
        self.appVersions.delegate = self
        self.appVersions.dataSource = self
        
        languageDataSource = GenericDataSource(tableView: languageTableView)
        languagesDelegate = LanguagesDelegate(tableView: languageTableView) { row, language in
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
        
        self.allLanguages?[0].version = "1.5"
        
        myList["translationList"] = self.translationList as AnyObject
        myList["language"] = self.allLanguages?[0].toJSONObjects() as AnyObject
        myList["newVersion"] = "/" + self.allLanguages![0].name + "/" + "1.5.json" as AnyObject
        
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
        
        self.getTranslationFile(filePath: filePath) { (succeeded: Bool, data: [String:String]) -> () in
            
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
        let selectedRow = comboBox.indexOfSelectedItem
        
        if selectedRow < 0 {
            return
        }
        
        self.currentLanguage = "English"
        self.currentVersion = "1.3.json"
        
        let filePath = "/"+self.currentLanguage! + "/" + self.currentVersion!
        
        self.getTranslation(filePath: filePath)
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return 3
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
