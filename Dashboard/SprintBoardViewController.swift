//
//  SprintBoardViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 27/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class SprintBoardViewController: NSViewController {
    
    @IBOutlet weak var todoListTableView: NSTableView!
    @IBOutlet weak var inProgressTableView: NSTableView!
    @IBOutlet weak var completeTableView: NSTableView!
    @IBOutlet weak var onHoldTableView: NSTableView!
    
    

    var todoListDataArray:[String] = ["Authentication","Login Issue","String Error","Crash on iPhone 7"]
    var inProgressDataArray:[String] = []
    var completeDataArray:[String] = []
    var onHoldDataArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let registeredTypes:[String] = [NSStringPboardType]
        todoListTableView.register(forDraggedTypes: registeredTypes)
        inProgressTableView.register(forDraggedTypes: registeredTypes)
        completeTableView.register(forDraggedTypes: registeredTypes)
        onHoldTableView.register(forDraggedTypes: registeredTypes)

        
        self.todoListTableView.delegate = self
        self.todoListTableView.dataSource = self
        
        self.inProgressTableView.delegate = self
        self.inProgressTableView.dataSource = self
        
        self.completeTableView.delegate = self
        self.completeTableView.dataSource = self
        
        self.onHoldTableView.delegate = self
        self.onHoldTableView.dataSource = self
        
        self.todoListTableView.reloadData()
        self.inProgressTableView.reloadData()
        self.completeTableView.reloadData()
        self.onHoldTableView.reloadData()
        
        
        // Do view setup here.
    }
    
}

extension SprintBoardViewController: NSTableViewDelegate,NSTableViewDataSource {
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        
        var numberOfRows:Int = 0;
        if (aTableView == todoListTableView) {
            numberOfRows = todoListDataArray.count
        }
        else if (aTableView == inProgressTableView) {
            numberOfRows = inProgressDataArray.count
        }
        else if (aTableView == completeTableView) {
            numberOfRows = completeDataArray.count
        }
        else if ( aTableView == onHoldTableView) {
            numberOfRows = onHoldDataArray.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
        var newString:String = ""
        if (tableView == todoListTableView) {
            newString = todoListDataArray[row]
        }
        else if (tableView == inProgressTableView) {
            newString = inProgressDataArray[row]
        }
        else if (tableView == completeTableView) {
            newString = completeDataArray[row]
        }
        else if(tableView == onHoldTableView) {
            newString = onHoldDataArray[row]
        }
        return newString;
    }
    
    
    func tableView(_ aTableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool
    {
        if ((aTableView == todoListTableView) || (aTableView == inProgressTableView)
            || (aTableView == completeTableView) || (aTableView == onHoldTableView)) {
            let data:Data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
            let registeredTypes:[String] = [NSStringPboardType]
            pboard.declareTypes(registeredTypes, owner: self)
            pboard.setData(data, forType: NSStringPboardType)
            return true
            
        }
        else
        {
            return false
        }
    }
    
    
    func tableView(_ aTableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int,
                   proposedDropOperation operation: NSTableViewDropOperation) -> NSDragOperation
    {
        
        if operation == .above {
            return .move
        }
        return NSDragOperation.every
        
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool
    {
        let data:Data = info.draggingPasteboard().data(forType: NSStringPboardType)!
        let rowIndexes:IndexSet = NSKeyedUnarchiver.unarchiveObject(with: data) as! IndexSet
        
    
        
        if ((tableView == todoListTableView) || (tableView == inProgressTableView)
            || (tableView == completeTableView) || (tableView == onHoldTableView)) {
            
            if ( (info.draggingSource() as! NSTableView) == tableView ) {
                print("draggin on same tableview")
                
                let newStr = self.removeFromTable(tableView: info.draggingSource() as! NSTableView, row: rowIndexes.first!)
                self.updateSameTable(tableView: tableView, row: rowIndexes.first!, value: newStr)
                
            }
            else {
            
                let newStr = self.removeFromTable(tableView: info.draggingSource() as! NSTableView, row: rowIndexes.first!)
            
                self.addToTable(tableView: tableView, value: newStr)
            }
            
            self.reloadAllTable()
            
            return true
        } else {
            return false
        }
        
        
        /*if ((info.draggingSource() as! NSTableView == inProgressTableView) && (tableView == inProgressTableView)) {
            let value:String = inProgressDataArray[rowIndexes.first!]
            inProgressDataArray.remove(at: rowIndexes.first!)
            if (row > inProgressDataArray.count)
            {
                inProgressDataArray.insert(value, at: row-1)
            }
            else
            {
                inProgressDataArray.insert(value, at: row)
            }
            inProgressTableView.reloadData()
            return true
        }
        else if ((info.draggingSource() as! NSTableView == todoListTableView) && (tableView == inProgressTableView)) {
            
            let value:String = todoListDataArray[rowIndexes.first!]
            todoListDataArray.remove(at: rowIndexes.first!)
            inProgressDataArray.append(value)
            todoListTableView.reloadData()
            inProgressTableView.reloadData()
            return true
        }
        else if ((info.draggingSource() as! NSTableView == todoListTableView) && (tableView == inProgressTableView))
        {
            let value:String = todoListDataArray[rowIndexes.first!]
            todoListDataArray.remove(at: rowIndexes.first!)
            inProgressDataArray.append(value)
            todoListTableView.reloadData()
            inProgressTableView.reloadData()
            return true
        }
        else if ((info.draggingSource() as! NSTableView == todoListTableView) && (tableView == inProgressTableView))
        {
            let value:String = todoListDataArray[rowIndexes.first!]
            todoListDataArray.remove(at: rowIndexes.first!)
            inProgressDataArray.append(value)
            todoListTableView.reloadData()
            inProgressTableView.reloadData()
            return true
        }
        else
        {
            return false
        }*/
        
    }
    
    func updateSameTable(tableView: NSTableView, row: Int, value: String) {
        
        switch tableView {
        case todoListTableView:
            if (row > todoListDataArray.count) {
                todoListDataArray.insert(value, at: row-1)
            }
            else {
                todoListDataArray.insert(value, at: row)
            }
            break
        case inProgressTableView:
            if (row > inProgressDataArray.count) {
                inProgressDataArray.insert(value, at: row-1)
            }
            else {
                inProgressDataArray.insert(value, at: row)
            }
            break
        case completeTableView:
            if (row > completeDataArray.count) {
                completeDataArray.insert(value, at: row-1)
            }
            else {
                completeDataArray.insert(value, at: row)
            }
            break
        case onHoldTableView:
            if (row > onHoldDataArray.count) {
                onHoldDataArray.insert(value, at: row-1)
            }
            else {
                onHoldDataArray.insert(value, at: row)
            }
            break
        default:
            print("Error with NSTableView")
        }
    
    }
    
    
    func addToTable( tableView: NSTableView, value: String ) {
        
        switch tableView {
        case todoListTableView:
            self.todoListDataArray.append(value)
            break
        case inProgressTableView:
            self.inProgressDataArray.append(value)
            break
        case completeTableView:
            self.completeDataArray.append(value)
            break
        case onHoldTableView:
            self.onHoldDataArray.append(value)
            break
        default:
            print("Error with NSTableView")
        }
        
    }

    
    func removeFromTable( tableView: NSTableView, row: Int) -> String {
        
        var returnStr = ""
        
        switch tableView {
        case todoListTableView:
            returnStr = self.todoListDataArray[row]
            self.todoListDataArray.remove(at: row)
            break
        case inProgressTableView:
            returnStr = self.inProgressDataArray[row]
            self.inProgressDataArray.remove(at: row)
            break
        case completeTableView:
            returnStr = self.completeDataArray[row]
            self.completeDataArray.remove(at: row)
            break
        case onHoldTableView:
            returnStr = self.onHoldDataArray[row]
            self.onHoldDataArray.remove(at: row)
            break
        default:
            print("Error with NSTableView")
        }
        
        return returnStr
        
    }
    
    func reloadAllTable() {
        self.inProgressTableView.reloadData()
        self.todoListTableView.reloadData()
        self.completeTableView.reloadData()
        self.onHoldTableView.reloadData()
    }
}
