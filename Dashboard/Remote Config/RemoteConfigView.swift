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
    var appKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config = Config()
        
        appNameDelegate = AppNameDelegate(comboxBox: comboBoxApp, selectionBlock: { ( row, app) in
            self.appKey = app.appKey
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
            
            let rcProperty = RCProperty(key: key, valueStr: value, valueNo: 1, row: row, type: "Text", parent: 0, settingPart: .MainSetting)
            self.loadEditTextView(rcProperty)
        }
        
        colorViewDataSource = ColorViewDataSource(tableView: colorTableView)
        colorViewDelegate = ColorViewDelegate(tableView: colorTableView ) { key, color, row in
            self.showColorPicker(name: key, color: color, row: row)
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
            
            var rcProperty = RCProperty(key: property, valueStr: value, valueNo: -1, row: 0, type: "Text", parent: self.parentRow, settingPart: .Properties)
            
            //Combobox list values
            if values.count > 1 {
                
                rcProperty.type = "List"
                rcProperty.settingPart = .Properties
                rcProperty.parent = self.parentRow
                
                self.loadComboBoxView(values, rcProperty)
            
            } else if values.count == 1 && values[0] == "number" {
                
                var list = [String]()
                
                for i in 0...40 {
                    list.append("\(i)")
                }
                
                rcProperty.type = "Text"
                rcProperty.settingPart = .Color
                rcProperty.parent = self.parentRow
                
                self.loadComboBoxView(list, rcProperty)
                
            }else if values.count == 1 && values[0] == "color" {
                
                let list = self.config?.colors
                
                rcProperty.type = "Text"
                rcProperty.settingPart = .Color
                rcProperty.parent = self.parentRow
                
                self.loadComboBoxView(list!, rcProperty)
            
            } else { // textView type
                self.loadEditTextView(rcProperty)
            }
        }
    }
    
    func loadEditTextView(_ rcProperty: RCProperty ) {
        
        let storyboard = NSStoryboard(name: "RemoteConfig", bundle: nil)
        let editPropertyWindowController = storyboard.instantiateController(withIdentifier: "EditTextValue") as! NSWindowController
        
        if let editWindow = editPropertyWindowController.window{
            
            let editTextViewControlller = editWindow.contentViewController as! EditTextViewControlller
            editTextViewControlller.rcProperty = rcProperty
            editTextViewControlller.delegate = self
            
            let application = NSApplication.shared()
            application.runModal(for: editWindow)
        }

    }
    
    func loadComboBoxView(_ list: [RCColor], _ rcProperty: RCProperty ) {
        
        let storyboard = NSStoryboard(name: "RemoteConfig", bundle: nil)
        let editListWindowController = storyboard.instantiateController(withIdentifier: "EditComboView") as! NSWindowController
        
        if let editListWindow = editListWindowController.window{
            
            let editListViewController = editListWindow.contentViewController as! EditListViewController
            editListViewController.colorList = list
            editListViewController.rcProperty = rcProperty
            editListViewController.delegate = self
            
            let application = NSApplication.shared()
            application.runModal(for: editListWindow)
        }
        
    }

    
    func loadComboBoxView(_ list: [String], _ rcProperty: RCProperty , _ keyEditable:Bool = false ) {
        
        let storyboard = NSStoryboard(name: "RemoteConfig", bundle: nil)
        let editListWindowController = storyboard.instantiateController(withIdentifier: "EditComboView") as! NSWindowController
        
        if let editListWindow = editListWindowController.window{
            
            let editListViewController = editListWindow.contentViewController as! EditListViewController
            editListViewController.list = list
            editListViewController.rcProperty = rcProperty
            editListViewController.keyEditable = keyEditable
            editListViewController.delegate = self
            
            let application = NSApplication.shared()
            application.runModal(for: editListWindow)
        }

    }
    
    
    func readConfigJSONFile(_ uiObject: String ) -> [String:Any] {
        if let path = Bundle.main.path(forResource: "config", ofType: "json") {
            
            if let jsonData = NSData(contentsOfFile: path) as Data? {
                
                do {
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any] {
                        
                        if let object = jsonResult[uiObject] as? [String:Any] {
                            
                            return object
                        }
                    }
                    
                } catch let error {
                    print(error)
                }
            }
        }
        
        return [:]
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
    
    func showColorPicker( name:String, color: NSColor, row: Int = 0 ) {
        
        let storyboard = NSStoryboard(name: "RemoteConfig", bundle: nil)
        let wordCountWindowController = storyboard.instantiateController(withIdentifier: "Color Picker") as! NSWindowController
        
        if let wordCountWindow = wordCountWindowController.window{

            let colorPickerViewController = wordCountWindow.contentViewController as! ColorPickerViewController
            colorPickerViewController.colorNameStr = name
            colorPickerViewController.blue = Float(color.blueComponent * 255)
            colorPickerViewController.red = Float(color.redComponent * 255)
            colorPickerViewController.green = Float(color.greenComponent * 255)
            colorPickerViewController.row = row
            colorPickerViewController.color = color
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
        let networkURL = "/api/"+self.appKey+"/remote/" + version//"https://timothybarnard.org/Scrap/appDataRequest.php?type=config"
        let dic = [String: AnyObject]()
        HTTPSConnection.httpGetRequest(params: dic, url: networkURL) { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            DispatchQueue.main.async {
                if (succeeded) {
                    print("Succeeded")
                    self.config = HTTPSConnection.parseJSONConfig(data: data)
                
                    if self.config != nil  {
                    
                        self.reloadAllData()
                    }
                    
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
            //let key = UniqueSting.apID()
            HTTPSConnection.httpPostRequest(params: data, endPoint: "/remote") { ( sent, message) in
                
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
        
        if let color = data as? RCColorProp {
            
            if color.row == -1 {
                let newColor = RCColor(blue: color.color.blue,
                                       green: color.color.green,
                                       red: color.color.red,
                                       alpha: color.color.alpha,
                                       name: color.color.name)
                self.config?.colors.append(newColor)
            } else {
                self.config?.colors[color.row] = color.color
            }
            self.reloadAllData()
        
        } else if let property = data as? RCProperty {
            
            if property.type == "List" {
                self.object?.objectProperties[property.key] = property.valueNo
            } else {
                self.object?.objectProperties[property.key] = property.valueStr
            }
            
            if property.settingPart == .MainSetting {
                
                self.config?.mainSettings[property.key] = property.valueStr
                
            }
            else if property.settingPart == SettingPart.Class {
                
                let newController = RCController(name: property.valueStr)
            
                self.config?.controllers.append(newController)
                
            } else if property.settingPart == SettingPart.Object {
                
                var properties = [String:Any]()
                
                for (item, _ ) in self.readConfigJSONFile(property.valueStr) {
                    
                    properties[item] = ""
                }
                
                var rcObject = RCObject(objectName: property.key, objectDescription: "", objectType: RCObjectType(rawValue: property.valueStr)! )
                rcObject.objectProperties = properties
                
                self.config?.controllers[property.parent].objectsList.append(rcObject)
                
            } else {
        
                self.config?.controllers[property.parent].objectsList[property.row] = self.object!
            
            
                self.loadDetailTable(self.config!.controllers[property.parent].objectsList[property.row])
            }
        }
        
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
        
        let rcProperty = RCProperty(key: "", valueStr: "",
                                    valueNo: 0, row: 0,
                                    type: "Text", parent: 0,
                                    settingPart: .MainSetting)
        self.loadEditTextView(rcProperty)
    }
    
    func addColor() {
        let color = NSColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        self.showColorPicker(name: "", color: color, row: -1)
    }
    
    func addClass() {
        
        let rcProperty = RCProperty(key: "name", valueStr: "",
                                    valueNo: 0, row: 0,
                                    type: "Text", parent: 0,
                                    settingPart: .Class)
        self.loadEditTextView(rcProperty)
    }
    
    func addProperty() {
        
        let rcProperty = RCProperty(key: "", valueStr: "",
                                    valueNo: 0, row: 0,
                                    type: "Text", parent: self.parentRow,
                                    settingPart: .Properties)
        self.loadEditTextView(rcProperty)
    }
    
    func addObject() {
        
        
        let values: [String] = ["UIImageView", "UITextField", "UICell", "UITableView", "UILabel", "Object"]
        
        
        let rcProperty = RCProperty(key: "name", valueStr: "",
                                    valueNo: 0, row: 0,
                                    type: "Text", parent: self.parentRow,
                                    settingPart: .Object)
        
        self.loadComboBoxView(values, rcProperty, true)

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
                    
                    menu.addItem(withTitle: "Add Property", action: #selector(self.addProperty), keyEquivalent: "")
                }
            }
            
            break
            
        case "MainMenu":
            
            if menu.items.count == 1 {
                
                menu.removeAllItems()
                
                //if self.object != nil {
                    
                    menu.addItem(withTitle: "Add Class", action: #selector(self.addClass), keyEquivalent: "")
                    menu.addItem(withTitle: "Add Object", action: #selector(self.addObject), keyEquivalent: "")
                    
//                    let convertMenu = NSMenu(title: "Add Object")
//                    convertMenu.delegate = self
//                    let convertMenuItem = NSMenuItem(title: "Convert Item ...", action: nil, keyEquivalent: "")
//                    
//                    menu.addItem(convertMenuItem)
//                    menu.setSubmenu(convertMenu, for: convertMenuItem)
               // }
            }

            
            break
            
        case "ColorMenu":
            
            if menu.items.count == 1 {
                
                menu.removeAllItems()
                
                menu.addItem(withTitle: "Add Color", action: #selector(self.addColor), keyEquivalent: "")

            }
            
            
            break
            
        default: break
        }
    }
}
