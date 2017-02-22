//
//  TextViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

struct ReturnObject {
    
    var key: String
    var value: String
    var id: Int
    
    init(value:String, id: Int, key: String = "") {
        self.value = value
        self.id = id
        self.key = key
    }
    
}


class TextViewController: NSViewController, NSWindowDelegate {
    
    var returnDelegate: ReturnDelegate?
    var labelString: String?
    var id: Int = 0
    
    @IBOutlet weak var viewLabel: NSTextField!
    @IBOutlet weak var viewTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.delegate = self
    }
    
    override func viewDidAppear() {
        self.viewLabel.stringValue = labelString!
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
    }
    
    @IBAction func doneutton(_ sender: Any) {
        
        let returnObj = ReturnObject(value: self.viewTextField.stringValue, id: self.id)
        
        self.returnDelegate?.sendBackData(data: returnObj)
        
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
}
