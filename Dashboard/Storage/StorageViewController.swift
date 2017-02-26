//
//  StorageViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class StorageViewController: NSViewController {

    
    @IBOutlet weak var totalTables: NSTextField!
    @IBOutlet weak var tableName: NSTextField!
    @IBOutlet weak var totalRecords: NSTextField!
    
    @IBOutlet weak var databaseTableView: NSTableView!
    
    @IBOutlet weak var mainTableView: NSTableView!
    @IBOutlet weak var detailOutLineView: NSOutlineView!
    
    fileprivate var databaseViewDelegate: DatabaseViewDelegate!
    fileprivate var databaseViewDataSource: StorageMainDataSource!
    
    fileprivate var storageMainDelegate: StorageMainDelegate!
    fileprivate var storageMainDataSource: StorageMainDataSource!
    
    fileprivate var storageDetailDataSource: StorageDetailDataSource!
    fileprivate var storageDetailDelegate: StorageDetailDelegate!
    
    var appKey: String = ""
    var allowDocumentMenu: Bool = false
    var detailObjectID: String = ""
    var currentCollection: String = ""
    var allRecords: GenericTable?
    var selectedDocRow: Int = -1
    var allTables = [Tables]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseViewDataSource = StorageMainDataSource(tableView: databaseTableView)
        databaseViewDelegate = DatabaseViewDelegate(tableView: databaseTableView) { appKey in
            self.appKey = appKey
            self.reloadMainTables(appKey: appKey)
        }
        
        storageMainDataSource = StorageMainDataSource(tableView: mainTableView)
        storageMainDelegate = StorageMainDelegate(tableView: mainTableView) { table, row in
            self.selectedDocRow = row
            self.currentCollection = table
            self.getTableValues(tableName: table, appKey: self.appKey)
        }
        
        storageDetailDataSource = StorageDetailDataSource(outlineView: detailOutLineView)
        storageDetailDelegate = StorageDetailDelegate(outlineView: detailOutLineView) { document, row in
            self.selectedDocRow = row
            self.findDocumentID(document)
        }
        
        self.reloadDatabaseTables()
        
        //self.reloadData()
    }
    
    func findDocumentID(_ document:Document ) {
        
        if (document.children?.count)! > 0 {
            
            for (_, child ) in (document.children?.enumerated())! {
                
                if child.key == "_id" {
                    self.allowDocumentMenu = true
                    self.detailObjectID = child.value as? String ?? ""
                    break
                }
            }
            
        } else {
            self.allowDocumentMenu = false
        }
        
    }
    
    
    @IBAction func importFileDatabase(_ sender: Any) {
        
        let storyboard = NSStoryboard(name: "Storage", bundle: nil)
        let importFileWindowController = storyboard.instantiateController(withIdentifier: "ImportFile") as! NSWindowController
        
        if let importFileWindow = importFileWindowController.window{
            
            let application = NSApplication.shared()
            application.runModal(for: importFileWindow)
        }
    }
    
    func reloadDatabaseTables() {
        
        var allDatabases = [TBApplication]()
        
        allDatabases.getAllInBackground(ofType: TBApplication.self) { (succeeded: Bool, data: [TBApplication]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    allDatabases = data
                    print("success")
                    self.databaseViewDataSource.reload(count: allDatabases.count)
                    self.databaseViewDelegate.reload(tableList: allDatabases)
                    
                    if allDatabases.count > 0 {
                        
                        let database = allDatabases.first
                        
                        if let appKey = database?.appKey {
                            self.appKey = appKey
                            self.reloadMainTables(appKey: appKey)
                        }
                    }
                    
                } else {
                    print("error")
                }
            }
        }
    }

    
    func reloadMainTables(appKey: String) {
        
        self.allTables = [Tables]()
        
        allTables.getAllInBackground(ofType:Tables.self, appKey: appKey) { (succeeded: Bool, data: [Tables]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    self.allTables = data
                    print("success")
                    
                    self.reloadCollection()
                    if self.allTables.count > 0 {
                        
                        let table = self.allTables.first
                        
                        if let tableName = table?.tableName {
                            
                            self.currentCollection = tableName
                            self.tableName.stringValue = tableName
                            self.totalTables.stringValue = "\(self.allTables.count)"
                            self.getTableValues(tableName: tableName, appKey: appKey)
                        }
                    }
//                    self.getTableValues(tableName: "Issue")
                } else {
                    print("error")
                }
            }
        }
    }
    
    func getTableValues( tableName: String, appKey: String ) {
        
        self.allRecords = GenericTable()
        
        allRecords?.getGenericAllInBackground(tableName: tableName, appKey: appKey) { (succeeded: Bool, data: GenericTable? ) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    self.allRecords = data!
                    print("success")
                    self.totalRecords.stringValue = "\(self.allRecords?.row.count ?? 0)"
                    self.tableName.stringValue = tableName
                    self.reloadDocuments()
                } else {
                    print("error")
                }
            }
        }
    }
    
    func reloadCollection() {
        self.storageMainDataSource.reload(count: self.allTables.count)
        self.storageMainDelegate.reload(tableList: self.allTables)
    }
    
    func reloadDocuments() {
        self.storageDetailDataSource.reload(records: (allRecords?.row)!)
    }
}

extension StorageViewController: NSMenuDelegate {
    
    func menuWillOpen(_ menu: NSMenu) {
        
        
    }
    
//    func showMessageBox( _ title: String, _ id: Int ) {
//        
//        let storyboard = NSStoryboard(name: "AlertTextField", bundle: nil)
//        let alertTextFieldWindowController = storyboard.instantiateController(withIdentifier: "AlertTextField") as! NSWindowController
//        
//        if let alertTextFieldWindow = alertTextFieldWindowController.window {
//            
//            let textViewController = alertTextFieldWindow.contentViewController as! TextViewController
//            textViewController.returnDelegate = self
//            textViewController.labelString = title
//            textViewController.id = id
//            
//            let application = NSApplication.shared()
//            application.runModal(for: alertTextFieldWindow)
//        }
//        
//    }
//    func showMessageBoxKeyValue( _ title: String, _ id: Int, _ key: String = "", _ value: String = "" ) {
//        
//        let storyboard = NSStoryboard(name: "AlertTextField", bundle: nil)
//        let alertTextFieldWindowController = storyboard.instantiateController(withIdentifier: "KeyValueWindow") as! NSWindowController
//        
//        if let alertTextFieldWindow = alertTextFieldWindowController.window {
//            
//            let textKeyValueController = alertTextFieldWindow.contentViewController as! TextKeyValueController
//            textKeyValueController.returnDelegate = self
//            textKeyValueController.labelString = title
//            textKeyValueController.id = id
//            textKeyValueController.value = value
//            textKeyValueController.key = key
//            
//            let application = NSApplication.shared()
//            application.runModal(for: alertTextFieldWindow)
//        }
//        
//    }
    
    
    func addLanguage() {
        //self.showMessageBox("Add Language", 1)
    }
    
    
    
    @discardableResult
    func dialogOKCancel(message: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = message
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "OK")
        return myPopup.runModal() == NSAlertFirstButtonReturn
    }
    
    func createAlert(_ message: String, _ text: String, style: NSAlertStyle = .informational ) -> NSAlert {

        let a = NSAlert()
        a.messageText = message
        a.informativeText = text
        a.addButton(withTitle: "OK")
        a.addButton(withTitle: "Cancel")
        a.alertStyle = style
        return a
    }
    
    
    func removeDocument() {
        
        let a = createAlert("Remove Document", "Are you sure you want to remove object with id: " + self.detailObjectID, style: .warning)
        
        a.beginSheetModal(for: self.view.window!, completionHandler: { (modalResponse) -> Void in
            if modalResponse == NSAlertFirstButtonReturn {
                print("Document deleted")
                
                let deleteRecord = GenericTable()
                deleteRecord.genericRemoveInBackground(self.detailObjectID, collectioName: self.currentCollection, appKey: self.appKey ) { (removed, response) in
                    DispatchQueue.main.async {
                        if (removed) {
                            print("success")
                            self.allRecords?.row.remove(at: self.selectedDocRow)
                            self.reloadDocuments()
                            self.selectedDocRow = -1;
                        } else {
                            print("error")
                        }
                    }
                }

            }
        })
    }
    
    func removeCollection() {
        
        let a = createAlert("Remove Collection", "Are you sure you want to remove collection name: " + self.currentCollection, style: .warning)
        
        a.beginSheetModal(for: self.view.window!, completionHandler: { (modalResponse) -> Void in
            if modalResponse == NSAlertFirstButtonReturn {
                print("Document deleted")
                
                let deleteRecord = GenericTable()
                deleteRecord.genericCollectionRemoveInBackground(self.currentCollection, appKey: self.appKey ) { (removed, response) in
                    DispatchQueue.main.async {
                        if (removed) {
                            print("success")
                            self.allTables.remove(at: self.selectedDocRow)
                            self.reloadCollection()
                            self.selectedDocRow = -1;
                        } else {
                            print("error")
                        }
                    }
                }
            }
        })
    }

    
    func addKey() {
        //self.showMessageBox("Add Key", 2)
    }
    
    func addKeyValueToLanguage( ) {
        //self.showMessageBoxKeyValue( "Add Translation for " + self.currentLanguage! , 3)
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        
        switch menu.title {
            
        case "Documents":
            
            menu.removeAllItems()
            
            if menu.items.count == 0 && self.allowDocumentMenu {
                
                menu.addItem(withTitle: "Remove", action: #selector(self.removeDocument), keyEquivalent: "")
                menu.addItem(withTitle: "Add", action: #selector(self.addLanguage), keyEquivalent: "")
            }
            break
            
        case "Collections":
            
            if menu.items.count == 1 {
                
                menu.removeAllItems()
                
                menu.addItem(withTitle: "Add new key", action: #selector(self.addKey), keyEquivalent: "")
            }
            
            break
        default: break
        }
    }
}
