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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseViewDataSource = StorageMainDataSource(tableView: databaseTableView)
        databaseViewDelegate = DatabaseViewDelegate(tableView: databaseTableView) { appKey in
            self.appKey = appKey
            self.reloadMainTables(appKey: appKey)
        }
        
        storageMainDataSource = StorageMainDataSource(tableView: mainTableView)
        storageMainDelegate = StorageMainDelegate(tableView: mainTableView) { table in
            self.getTableValues(tableName: table, appKey: self.appKey)
        }
        
        storageDetailDataSource = StorageDetailDataSource(outlineView: detailOutLineView)
        storageDetailDelegate = StorageDetailDelegate(outlineView: detailOutLineView)
        
        self.reloadDatabaseTables()
        
        //self.reloadData()
    }
    @IBAction func importFileDatabase(_ sender: Any) {
        
        let storyboard = NSStoryboard(name: "Storage", bundle: nil)
        let importFileWindowController = storyboard.instantiateController(withIdentifier: "ImportFile") as! NSWindowController
        
        if let importFileWindow = importFileWindowController.window{
            
            let application = NSApplication.shared()
            application.runModal(for: importFileWindow)
        }
    }
    
    func reloadData() {
        
        let deleteRecord = GenericTable()
        deleteRecord.genericRemoveInBackground("0d2cd597-bb34-4b97-9bc9-476af56ce843", collectioName: "Languages") { (removed, response) in
            DispatchQueue.main.async {
                if (removed) {
                    print("success")
                } else {
                    print("error")
                }
            }
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
        
        var allTables = [Tables]()
        
        allTables.getAllInBackground(ofType:Tables.self, appKey: appKey) { (succeeded: Bool, data: [Tables]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    allTables = data
                    print("success")
                    self.storageMainDataSource.reload(count: allTables.count)
                    self.storageMainDelegate.reload(tableList: allTables)
                    
                    if allTables.count > 0 {
                        
                        let table = allTables.first
                        
                        if let tableName = table?.tableName {
                            
                            self.tableName.stringValue = tableName
                            self.totalTables.stringValue = "\(allTables.count)"
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
        
        var allRecords = GenericTable()
        
        allRecords.getGenericAllInBackground(tableName: tableName, appKey: appKey) { (succeeded: Bool, data: GenericTable? ) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    allRecords = data!
                    print("success")
                    self.storageDetailDataSource.reload(records: allRecords.row)
                    self.totalRecords.stringValue = "\(allRecords.row.count)"
                    self.tableName.stringValue = tableName
                } else {
                    print("error")
                }
            }
        }

        
    }
    
}
