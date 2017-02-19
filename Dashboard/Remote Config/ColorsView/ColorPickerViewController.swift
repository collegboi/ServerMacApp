//
//  ColorPickerViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class ColorPickerViewController: NSViewController {
    
    
    @IBOutlet weak var colorView: NSView!
    @IBOutlet weak var redSlider: NSSlider!
    @IBOutlet weak var greenSlider: NSSlider!
    @IBOutlet weak var blueSlider: NSSlider!
    
    @IBOutlet weak var redTextField: NSTextField!
    @IBOutlet weak var greenTextField: NSTextField!
    @IBOutlet weak var blueTextFIeld: NSTextField!
    
    @IBOutlet weak var colorName: NSTextField!
    var color: NSColor?
    var delegate: ReturnDelegate?
    
    var row: Int = -1
    
    var colorNameStr: String = "" {
        didSet {
            self.colorName.stringValue = colorNameStr
        }
    }
    
    var red : Float = 124 {
        didSet {
            let redRound = red.roundTo(places: 2)
            self.redTextField.stringValue = "\(redRound)"
            self.redSlider.floatValue = redRound
            self.updateView()
        }
    }
    
    var green : Float = 124 {
        didSet {
            let greenRound = green.roundTo(places: 2)
            self.greenTextField.stringValue = "\(greenRound)"
            self.greenSlider.floatValue = greenRound
            self.updateView()
        }
    }
    
    var blue : Float = 124 {
        didSet {
            let blueRound = blue.roundTo(places: 2)
            self.blueTextFIeld.stringValue = "\(blueRound)"
            self.blueSlider.floatValue = blueRound
            self.updateView()
        }
    }
    
//    var alphaVal : Float = 1 {
//        didSet {
//            self.alphaSlider.value = alphaVal.roundTo(places: 2)
//            self.updateView()
//        }
//    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear() {
        self.colorView.setBackgroundColor(self.color!)
    }
    
    func updateView() {
        
        self.colorNameStr = self.colorName.stringValue
        
        var redColor : CGFloat = 0
        if let n = NumberFormatter().number(from: self.redTextField.stringValue) {
            redColor = CGFloat(n)
        }
        
        var greenColor : CGFloat = 0
        if let n = NumberFormatter().number(from: self.greenTextField.stringValue) {
            greenColor = CGFloat(n)
        }
        
        var blueColor : CGFloat = 0
        if let n = NumberFormatter().number(from: self.blueTextFIeld.stringValue) {
            blueColor = CGFloat(n)
        }
        
        //let alpha = self.alphaSlider.value
        
        let color1 = NSColor(red: redColor/255.0, green: greenColor/255.0, blue: blueColor/255.0, alpha: CGFloat(1))
        
        self.colorView.setBackgroundColor(color1)
    }

    
    @IBAction func blueSlider(_ sender: Any) {
        self.blue = ( sender as! NSSlider).floatValue.roundTo(places: 2)
    }
    
    
    @IBAction func greenSlider(_ sender: Any) {
        self.green = ( sender as! NSSlider).floatValue.roundTo(places: 2)
    }
    
    @IBAction func redSlider(_ sender: Any) {
        self.red = ( sender as! NSSlider).floatValue.roundTo(places: 2)
    }
    
    @IBAction func dismissSaveColorPickerWindow(sender: NSButton) {
        
        let updateColor = RCColor(blue: CGFloat(self.blue), green: CGFloat(self.green), red: CGFloat(self.red), alpha: 1, name: self.colorNameStr)
        
        let rcColor = RCColorProp(color: updateColor, row: self.row)
        
        delegate?.sendBackData(data: rcColor)
        
        let application = NSApplication.shared()
        application.stopModal()
        
    }
    
    @IBAction func dismissColorPickerWindow(sender: NSButton) {
        
        let application = NSApplication.shared()
        application.stopModal()

    }
    
    /*func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        self.updateView()
        return false
    }*/
    
}
