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
        settingsViewDelegate = SettingsViewDelegate(tableView: settingsTableView ) { key, value in
        
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
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func showColorPicker( name:String, color: NSColor ) {
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
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
                    
                    
                    //                    if let json = self.config!.toJSONObjects() {
                    //                        print(json)
                    //                        self.sendRemoteConfigFiles(json: json)
                    //                    }
                
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

