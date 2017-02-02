//
//  StorageViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class StorageViewController: NSViewController {

    
    @IBOutlet weak var mainTableView: NSTableView!
    @IBOutlet weak var detailTableView: NSTableView!
    
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
        
        storageDetailDataSource = StorageDetailDataSource(tableView: detailTableView)
        storageDetailDelegate = StorageDetailDelegate(tableView: detailTableView)
        
        // Do view setup here.
        
        self.reloadMainTables()
    }
    
    func reloadMainTables() {
        
        var allTables = [Tables]()
        
        allTables.getAllInBackground(ofType:Tables.self) { (succeeded: Bool, data: [Tables]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    allTables = data
                    print("scucess")
                    self.storageMainDataSource.reload(count: allTables.count)
                    self.storageMainDelegate.reload(tableList: allTables)
                    
                    let table = allTables.first
                    self.getTableValues(tableName: table!.tableName)
                    
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
                    print("scucess")
                    self.storageDetailDataSource.reload(count: allRecords.row.count )
                    self.storageDetailDelegate.reload(tableList: allRecords)
                    self.detailTableView.reloadData()
                    
                } else {
                    print("error")
                }
            }
        }

        
    }
    
}
