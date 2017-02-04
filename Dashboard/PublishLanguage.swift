//
//  PublishLanguage.swift
//  Dashboard
//
//  Created by Timothy Barnard on 04/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class PublishLanguage: NSViewController, NSWindowDelegate {

    var allLanguages: [Languages]?
    var publishVersionStr:String?
    
    fileprivate var publishLangDelegate: PublishLangDelegate!
    fileprivate var publishLangDataSource: GenericDataSource!
    
    @IBOutlet weak var publishLanguageTableView:NSTableView!
    @IBOutlet weak var publishVersion: NSTextField!
    
    var delegate: ReturnDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.delegate = self
        
        publishLangDelegate = PublishLangDelegate(tableView: publishLanguageTableView)
        publishLangDataSource = GenericDataSource(tableView: publishLanguageTableView)
        
    }
    
    override func viewWillAppear() {
        
        if publishVersionStr != nil {
            self.publishVersion.stringValue = publishVersionStr!
        }
        
        if allLanguages != nil {
            
            publishLangDataSource.reload(count: self.allLanguages!.count)
            publishLangDelegate.reload(languages: self.allLanguages!)
            
        }
        
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
        
        delegate?.sendBackData(data: self.allLanguages!)
    }
    
    
}
