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
    
    @IBOutlet weak var predicateEditor: NSPredicateEditor!
    
    @IBOutlet weak var mainTableView: NSTableView!
    @IBOutlet weak var detailOutLineView: NSOutlineView!
    
    fileprivate var storageMainDelegate: StorageMainDelegate!
    fileprivate var storageMainDataSource: StorageMainDataSource!
    
    fileprivate var storageDetailDataSource: StorageDetailDataSource!
    fileprivate var storageDetailDelegate: StorageDetailDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageMainDataSource = StorageMainDataSource(tableView: mainTableView)
        storageMainDelegate = StorageMainDelegate(tableView: mainTableView) { table in
            self.getTableValues(tableName: table)
        }
        
        storageDetailDataSource = StorageDetailDataSource(outlineView: detailOutLineView)
        storageDetailDelegate = StorageDetailDelegate(outlineView: detailOutLineView)
        
        // Do view setup here.
        
        let expression = NSExpression(forKeyPath: "test")
        
        let rowTemplate = NSPredicateEditorRowTemplate(leftExpressions: [expression], rightExpressionAttributeType: .stringAttributeType, modifier: .all, operators: [1], options: .allZeros)
        
        self.predicateEditor.rowTemplates.append(rowTemplate)
        
        
        self.reloadMainTables()
        
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
    
    func reloadMainTables() {
        
        var allTables = [Tables]()
        
        allTables.getAllInBackground(ofType:Tables.self) { (succeeded: Bool, data: [Tables]) -> () in
            
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
                            self.getTableValues(tableName: tableName)
                        }
                    }
//                    self.getTableValues(tableName: "Issue")
                } else {
                    print("error")
                }
            }
        }
    }
    
    func getTableValues( tableName: String ) {
        
        var allRecords = GenericTable()
        
        allRecords.getGenericAllInBackground(tableName: tableName) { (succeeded: Bool, data: GenericTable? ) -> () in
            
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
