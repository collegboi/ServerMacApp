//
//  TextKeyValueController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class TextKeyValueController: NSViewController, NSWindowDelegate {
    
    var returnDelegate: ReturnDelegate?
    var labelString: String?
    var id: Int = 0
    
    var key: String?
    var value: String?
    
    @IBOutlet weak var viewLabel: NSTextField!
    @IBOutlet weak var keyTextField: NSTextField!
    @IBOutlet weak var valueTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.delegate = self
    }
    
    override func viewDidAppear() {
        self.viewLabel.stringValue = labelString!
        self.keyTextField.stringValue = key!
        self.valueTextField.stringValue = value!
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
    }
    
    @IBAction func doneutton(_ sender: Any) {
        
        let returnObj = ReturnObject(value: self.valueTextField.stringValue, id: self.id, key: self.keyTextField.stringValue )
        
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

