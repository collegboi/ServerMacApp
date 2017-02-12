//
//  EditTextViewControlller.swift
//  Dashboard
//
//  Created by Timothy Barnard on 11/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class EditTextViewControlller: NSViewController {

    var keyString = ""
    var valueString = ""
    var row: Int = -1
    var parentRow: Int = -1
    
    var delegate: ReturnDelegate?
    
    @IBOutlet weak var keyTextField: NSTextField!
    @IBOutlet weak var valueTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear() {
        self.keyTextField.stringValue = keyString
        self.valueTextField.stringValue = valueString
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        let application = NSApplication.shared()
        application.stopModal()
    }
    @IBAction func doneButton(_ sender: Any) {
        
        let rcProperty = RCProperty(key: self.keyTextField.stringValue, valueStr: self.valueTextField.stringValue, valueNo: -1, row: row, type: "Text", parent: self.parentRow)
        
        self.delegate?.sendBackData(data: rcProperty)
        
        let application = NSApplication.shared()
        application.stopModal()
    }
}
