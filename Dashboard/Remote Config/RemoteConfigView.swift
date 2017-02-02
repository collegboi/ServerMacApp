//
//  RemoteConfigView.swift
//  Dashboard
//
//  Created by Timothy Barnard on 20/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

protocol ReturnDelegate {
    func sendBackData(data: Any)
}

class RemoteConigViewController: NSViewController {
    
    var config : Config?
    
    fileprivate struct Constants {
        static let headerCellID = "HeaderCell"
        static let volumeCellID = "VolumeCell"
    }
    
    @IBOutlet var view1: NSView!
    @IBOutlet var view2: NSView!
    @IBOutlet var view3: NSView!
    @IBOutlet var view4: NSView!
    
    
    fileprivate var mainDataSource: MainViewDataSource!
    fileprivate var mainDelegate: MainViewDelegate!
    
    fileprivate var detailDataSource: DetailViewDataSource!
    fileprivate var detailDelegate: DetailViewDelegate!
    
    fileprivate var settingsViewDelegate: SettingsViewDelegate!
    fileprivate var settingsViewDataSource: SettingsViewDataSource!
    
    fileprivate var colorViewDelegate: ColorViewDelegate!
    fileprivate var colorViewDataSource: ColorViewDataSource!
    
    @IBOutlet var mainOutlineView: NSOutlineView!
    @IBOutlet var detailOutlineView: NSOutlineView!
    
    @IBOutlet var settingsTableView: NSTableView!
    @IBOutlet var colorTableView: NSTableView!
    
    var pathRow: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view1.layer?.backgroundColor = NSColor.lightGray.cgColor
        self.view2.layer?.backgroundColor = NSColor.lightGray.cgColor
        self.view3.layer?.backgroundColor = NSColor.lightGray.cgColor
        self.view4.layer?.backgroundColor = NSColor.lightGray.cgColor
        
        self.view1.layer?.cornerRadius = 10
        self.view2.layer?.cornerRadius = 10
        self.view3.layer?.cornerRadius = 10
        self.view4.layer?.cornerRadius = 10
        
        mainDataSource = MainViewDataSource(outlineView: mainOutlineView)
        mainDelegate = MainViewDelegate(outlineView: mainOutlineView) { volume in
            self.showVolumeInfo(volume)
        }
        
        detailDataSource = DetailViewDataSource(outlineView: detailOutlineView)
        detailDelegate = DetailViewDelegate(outlineView: detailOutlineView)
        
        settingsViewDataSource = SettingsViewDataSource(tableView: settingsTableView)
        settingsViewDelegate = SettingsViewDelegate(tableView: settingsTableView ) { key, value, row in
            self.pathRow = row
        }
        
        colorViewDataSource = ColorViewDataSource(tableView: colorTableView)
        colorViewDelegate = ColorViewDelegate(tableView: colorTableView ) { key, color in
            self.showColorPicker(name: key, color: color)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.getRemoteConfigFiles()
    }
    
    func reloadSettingsTableView() {
        self.settingsViewDataSource.reload(count: self.config!.mainSettings.count)
        self.settingsViewDelegate.reload(mainSettings: self.config!.mainSettings)
    }
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func showColorPicker( name:String, color: NSColor ) {
        
        let storyboard = NSStoryboard(name: "RemoteConfig", bundle: nil)
        let wordCountWindowController = storyboard.instantiateController(withIdentifier: "Color Picker") as! NSWindowController
        
        if let wordCountWindow = wordCountWindowController.window{
            

            let colorPickerViewController = wordCountWindow.contentViewController as! ColorPickerViewController
            colorPickerViewController.colorNameStr = name
            colorPickerViewController.blue = Float(color.blueComponent)
            colorPickerViewController.red = Float(color.redComponent)
            colorPickerViewController.green = Float(color.greenComponent)
            colorPickerViewController.delegate = self
            
            let application = NSApplication.shared()
            application.runModal(for: wordCountWindow)
        }
    }
    
    func showVolumeInfo(_ volume: RCObject) {
        
        detailDataSource.reload(keyValuePairs: volume.objectProperties  )
        
    }
    
    func reloadAllData() {
        
        mainDataSource.reload( config: self.config! )
        
        settingsViewDelegate.reload(mainSettings: self.config!.mainSettings)
        settingsViewDataSource.reload(count: self.config!.mainSettings.count)
        
        colorViewDelegate.reload(colorSettings: self.config!.colors)
        colorViewDataSource.reload(count: self.config!.colors.count)
    }
    
    func getRemoteConfigFiles() {
        // Correct url and username/password
        
        print("sendRawTimetable")
        let networkURL = "https://timothybarnard.org/Scrap/appDataRequest.php?type=config"
        let dic = [String: AnyObject]()
        HTTPSConnection.httpRequest(params: dic, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            DispatchQueue.main.async {
                if (succeeded) {
                    print("Succeeded")
                    self.config = HTTPSConnection.parseJSONConfig(data: data)
                
                    self.reloadAllData()
                    
                } else {
                    print("Error")
                }
            }
        }
    }
}

extension RemoteConigViewController: ReturnDelegate {
    
    func sendBackData( data: Any ) {
        
        self.config?.colors[0] = (data as! RCColor)
        self.reloadAllData()
        
    }
    
}

extension RemoteConigViewController: NSMenuDelegate {
    
    func menuWillOpen(_ menu: NSMenu) {
        
    }
    
    func removeMainSetting() {
        if self.pathRow >= 0 {
            let key = self.config?.mainSettings.getKeyAtIndex(index: self.pathRow)
            self.config!.mainSettings.removeValue(forKey: key!)
            self.reloadSettingsTableView()
            self.pathRow = -1
        }
    }
    func addMainSetting() {
        self.config?.mainSettings[" "] = " "
        self.reloadSettingsTableView()
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        
        switch menu.title {
            
        case "Popup":
            
            // Check if the menu is already correctly initialized
            
            if menu.items.count == 1 { // When 1, there is the item that was defined in the XIB
                
                
                // Get rid of the item that is defined in the XIB
                
                menu.removeAllItems()
                
                
                // Add the default "remove" item
                
                menu.addItem(withTitle: "Remove", action: #selector(self.removeMainSetting), keyEquivalent: "")
                menu.addItem(withTitle: "Add", action: #selector(self.addMainSetting), keyEquivalent: "")
                
//                // Add a submenu to add items
//                
//                let addMenu = NSMenu(title: "Add")
//                addMenu.delegate = self
//                let addMenuItem = NSMenuItem(title: "Add Item ...", action: nil, keyEquivalent: "")
//                
//                menu.addItem(addMenuItem)
//                menu.setSubmenu(addMenu, for: addMenuItem)
//                
//                
//                // Add a submenu to convert items
//                
//                let convertMenu = NSMenu(title: "Convert")
//                convertMenu.delegate = self
//                let convertMenuItem = NSMenuItem(title: "Convert Item ...", action: nil, keyEquivalent: "")
//                
//                menu.addItem(convertMenuItem)
//                menu.setSubmenu(convertMenu, for: convertMenuItem)
//                
            }
            
            
        case "Add":
            
            // Build this menu if there are no items yet
            
            if menu.items.count == 0 {
                
                menu.addItem(withTitle: "Null", action: Selector(("addNull:")), keyEquivalent: "")
                menu.addItem(withTitle: "Bool", action: Selector(("addBool:")), keyEquivalent: "")
                menu.addItem(withTitle: "Number", action: Selector(("addNumber:")), keyEquivalent: "")
            }
            
            
        case "Convert": break
            
            // This is done dynamically, so get rid of the existing items
            
//            menu.removeAllItems()
//            
//            
//            // Now it depends on what exactly is in this line.
//            
//            if let object = document.determineObject() {
//                
//                switch object {
//                    
//                case .NULL:
//                    menu.addItem(withTitle: "To Bool", action: Selector("convertToBool:"), keyEquivalent: "")
//                    menu.addItem(withTitle: "To Number", action: "convertToNumber:", keyEquivalent: "")
//                    
//                case .BOOL:
//                    menu.addItemWithTitle("To Null", action: "convertToNull:", keyEquivalent: "")
//                    menu.addItemWithTitle("To Number", action: Selector("convertToNumber:"), keyEquivalent: "")
//                    
//                }
//            }
//            
            
        default: break
        }
    }
}

