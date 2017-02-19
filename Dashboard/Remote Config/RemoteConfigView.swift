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

    @IBOutlet weak var comboBoxVersion: NSComboBox!
    @IBOutlet weak var comboBoxApp: NSComboBox!
    
    fileprivate var appNameDelegate: AppNameDelegate!
    fileprivate var appNameDataSource: AppNameDataSource!
    
    fileprivate var appVersionDelegate: AppVersionDelegate!
    fileprivate var appVersionDataSource: AppNameDataSource!
    
    var pathRow: Int = -1
    var parentRow: Int = -1
    var object: RCObject?
    var applicationID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appNameDelegate = AppNameDelegate(comboxBox: comboBoxApp, selectionBlock: { ( row, app) in
            self.applicationID = (app.objectID?.objectID)!
            self.getAllAppsVersions((app.objectID?.objectID)!)
        })
        
        appNameDataSource = AppNameDataSource(comboxBox: comboBoxApp)
        
        appVersionDelegate = AppVersionDelegate(comboxBox: comboBoxVersion, selectionBlock: { ( row, version) in
            self.getRemoteConfigFiles(version: version.version )
        })
        
        appVersionDataSource = AppNameDataSource(comboxBox: comboBoxVersion)
        
        
        mainDataSource = MainViewDataSource(outlineView: mainOutlineView)
        mainDelegate = MainViewDelegate(outlineView: mainOutlineView) { volume, row, parent in
            self.object = volume
            self.pathRow = row
            self.parentRow = parent
            self.loadDetailTable(volume)
        }
        
        detailDataSource = DetailViewDataSource(outlineView: detailOutlineView)
        detailDelegate = DetailViewDelegate(outlineView: detailOutlineView) { row, value in
            self.loadEditView( value.key, value.value )
        }
        
        settingsViewDataSource = SettingsViewDataSource(tableView: settingsTableView)
        settingsViewDelegate = SettingsViewDelegate(tableView: settingsTableView ) { key, value, row in
            self.pathRow = row
        }
        
        colorViewDataSource = ColorViewDataSource(tableView: colorTableView)
        colorViewDelegate = ColorViewDelegate(tableView: colorTableView ) { key, color in
            self.showColorPicker(name: key, color: color)
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.getAllApps()
    }
    
    func getAllAppsVersions(_ appID: String ) {
        
        var allVersions = [RemoteConfig]()
        
         allVersions.getFilteredInBackground(ofType: RemoteConfig.self, query: ["applicationID": appID as AnyObject ]) { (retrieved, versions) in
            DispatchQueue.main.async {
                if retrieved {
                    allVersions = versions
                    
                    for version in versions {
                        self.comboBoxVersion.addItem(withObjectValue: version.version)
                    }
                    
                    self.appVersionDelegate.reload(versions)
                    self.appVersionDataSource.reload(versions.count)
                }
            }
        }
    }
    
    func getAllApps() {
        
        var allApps = [TBApplication]()
        
        allApps.getAllInBackground(ofType: TBApplication.self) { (retrieved, apps) in
            DispatchQueue.main.async {
                if retrieved {
                    allApps = apps
                    
                    for app in apps {
                        self.comboBoxApp.addItem(withObjectValue: app.name)
                    }
                    
                    self.appNameDelegate.reload(apps)
                    self.appNameDataSource.reload(apps.count)
                }
            }
        }
    }
    
    func loadEditView(_ property: String, _ value: String ) {
        
        if self.object != nil {
        
            let values = self.readConfigJSONFile((self.object?.objectType.rawValue)!, property)
            
            //Combobox list values
            if values.count > 1 {
                self.loadComboBoxView(values, property, "List", self.pathRow)
            
            } else if values.count == 1 && values[0] == "color" {
                
                let list = self.config?.colors
                
                self.loadComboBoxView(list!, property, "Text", self.pathRow)
            
            } else { // textView type
                self.loadEditTextView(property, value, self.pathRow)
            }
        }
    }
    
    func loadEditTextView(_ key: String, _ value: String, _ row: Int) {
        
        let storyboard = NSStoryboard(name: "RemoteConfig", bundle: nil)
        let editPropertyWindowController = storyboard.instantiateController(withIdentifier: "EditTextValue") as! NSWindowController
        
        if let editWindow = editPropertyWindowController.window{
            
            let editTextViewControlller = editWindow.contentViewController as! EditTextViewControlller
            editTextViewControlller.keyString = key
            editTextViewControlller.valueString = value
            editTextViewControlller.row = row
            editTextViewControlller.parentRow = self.parentRow
            editTextViewControlller.delegate = self
            
            let application = NSApplication.shared()
            application.runModal(for: editWindow)
        }

    }
    
    func loadComboBoxView(_ list: [RCColor], _ key : String, _ type: String, _ row: Int ) {
        
        let storyboard = NSStoryboard(name: "RemoteConfig", bundle: nil)
        let editListWindowController = storyboard.instantiateController(withIdentifier: "EditComboView") as! NSWindowController
        
        if let editListWindow = editListWindowController.window{
            
            let editListViewController = editListWindow.contentViewController as! EditListViewController
            editListViewController.colorList = list
            editListViewController.keyValue = key
            editListViewController.type = type
            editListViewController.row = row
            editListViewController.parentRow = self.parentRow
            editListViewController.delegate = self
            
            let application = NSApplication.shared()
            application.runModal(for: editListWindow)
        }
        
    }

    
    func loadComboBoxView(_ list: [String], _ key : String, _ type: String, _ row: Int ) {
        
        let storyboard = NSStoryboard(name: "RemoteConfig", bundle: nil)
        let editListWindowController = storyboard.instantiateController(withIdentifier: "EditComboView") as! NSWindowController
        
        if let editListWindow = editListWindowController.window{
            
            let editListViewController = editListWindow.contentViewController as! EditListViewController
            editListViewController.list = list
            editListViewController.keyValue = key
            editListViewController.type = type
            editListViewController.row = row
            editListViewController.parentRow = self.parentRow
            editListViewController.delegate = self
            
            let application = NSApplication.shared()
            application.runModal(for: editListWindow)
        }

    }
    
    func readConfigJSONFile(_ uiObject: String, _ property: String ) -> [String] {
        if let path = Bundle.main.path(forResource: "config", ofType: "json") {
            
            if let jsonData = NSData(contentsOfFile: path) as Data? {
                
                do {
                
                    if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any] {
                        
                        if let object = jsonResult[uiObject] as? [String:Any] {
                            
                            if let  list = object[property] as? [String]  {
                                return list
                            }
                            else if let strVal = object[property] as? String {
                                return [strVal]
                            }
                        }
                    }
                    
                } catch let error {
                    print(error)
                }
            }
        }
        
        return [""]
    }
    
    func reloadSettingsTableView() {
        self.settingsViewDataSource.reload(count: self.config!.mainSettings.count)
        self.settingsViewDelegate.reload(mainSettings: self.config!.mainSettings)
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
    
    func loadDetailTable(_ volume: RCObject) {
        detailDataSource.reload(keyValuePairs: volume.objectProperties  )
    }
    
    func reloadAllData() {
        
        mainDataSource.reload( config: self.config! )
        
        settingsViewDelegate.reload(mainSettings: self.config!.mainSettings)
        settingsViewDataSource.reload(count: self.config!.mainSettings.count)
        
        colorViewDelegate.reload(colorSettings: self.config!.colors)
        colorViewDataSource.reload(count: self.config!.colors.count)
    }
    
    func getRemoteConfigFiles( version: String ) {
        // Correct url and username/password
        
        print("sendRawTimetable")
        let networkURL = "/api/94a12bfc-223d-4f71-9336-fc4ac94f86d4/remote/" + version//"https://timothybarnard.org/Scrap/appDataRequest.php?type=config"
        let dic = [String: AnyObject]()
        HTTPSConnection.httpGetRequest(params: dic, url: networkURL) { (succeeded: Bool, data: NSData) -> () in
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
    
    func sendConfigFiles() {
    
        self.config?.version = self.comboBoxVersion.stringValue
        self.config?.applicationID = self.applicationID
        
        if let data = self.config?.toData() {
            let key = UniqueSting.apID()
            HTTPSConnection.httpPostRequest(params: data, endPoint: "/api/"+key+"/remote") { ( sent, message) in
                
                DispatchQueue.main.async {
                    
                    if sent {
                        print("sent")
                    } else {
                        print("not sent")
                    }
                }
            }

        }
    }
    
    @IBAction func publishButton(_ sender: Any) {
        self.sendConfigFiles()
    }
}

extension RemoteConigViewController: ReturnDelegate {
    
    func sendBackData( data: Any ) {
        
        if let color = data as? RCColor {
            self.config?.colors[0] = color
            self.reloadAllData()
        
        } else if let property = data as? RCProperty {
            
            if property.type == "List" {
                self.object?.objectProperties[property.key] = property.valueNo
            } else {
                self.object?.objectProperties[property.key] = property.valueStr
            }
        
            self.config?.controllers[property.parent].objectsList[property.row] = self.object!
            
            
            self.loadDetailTable(self.config!.controllers[property.parent].objectsList[property.row])
        }
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
            
            if menu.items.count == 1 {
                
                menu.removeAllItems()
                
                menu.addItem(withTitle: "Remove", action: #selector(self.removeMainSetting), keyEquivalent: "")
                menu.addItem(withTitle: "Add", action: #selector(self.addMainSetting), keyEquivalent: "")
            }
            break
            
        case "PropMenu":
        
            if menu.items.count == 1 {
                
                menu.removeAllItems()
                
                if self.object != nil {
                    
                    let addMenu = NSMenu(title: "Add")
                    addMenu.delegate = self
                    let addMenuItem = NSMenuItem(title: "Add Item ...", action: nil, keyEquivalent: "")

                    menu.addItem(addMenuItem)
                    menu.setSubmenu(addMenu, for: addMenuItem)
                    
                    let convertMenu = NSMenu(title: "Convert")
                    convertMenu.delegate = self
                    let convertMenuItem = NSMenuItem(title: "Convert Item ...", action: nil, keyEquivalent: "")

                    menu.addItem(convertMenuItem)
                    menu.setSubmenu(convertMenu, for: convertMenuItem)
                }
            }
            
            break
            
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
