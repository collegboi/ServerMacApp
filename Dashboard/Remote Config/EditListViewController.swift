//
//  EditListViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 11/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class EditListViewController: NSViewController {

    var list = [String]()
    var colorList = [RCColor]()
    
    var keyEditable: Bool = false

    var rcProperty: RCProperty?
    var delegate: ReturnDelegate?
    
    var returnString = ""
    var returnNo = 0
    
    @IBOutlet weak var keyTextField: NSTextField!
    @IBOutlet weak var comboxBox: NSComboBox!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.comboxBox.delegate = self
    }
    
    override func viewDidAppear() {
        self.keyTextField.stringValue = (rcProperty?.key)!
        self.keyTextField.isEditable = keyEditable
        
        for item in self.list {
            self.comboxBox.addItem(withObjectValue: item)
        }
        
        for color in self.colorList {
            let view = NSView()
            view.setBackgroundColor(NSColor(colorLiteralRed: Float(CGFloat(color.red/255)),
                                            green: Float(CGFloat(color.green/255)),
                                            blue: Float(CGFloat(color.blue/255)), alpha: 1))
            self.comboxBox.addItem(withObjectValue: color.name)
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        let rcProperty1 = RCProperty(key: self.keyTextField.stringValue,
                                    valueStr: self.returnString,
                                    valueNo: self.returnNo,
                                    row: self.rcProperty!.row,
                                    type: self.rcProperty!.type,
                                    parent: self.rcProperty!.parent,
                                    settingPart: self.rcProperty!.settingPart)
        
        self.delegate?.sendBackData(data: rcProperty1 )
        
        let application = NSApplication.shared()
        application.stopModal()
    }
}

extension EditListViewController: NSComboBoxDelegate {
    
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        guard let comboBox = notification.object as? NSComboBox else {
            return
        }
        
        returnString = "\(comboBox.objectValueOfSelectedItem!)"
        returnNo = comboBox.indexOfSelectedItem
    }
}
