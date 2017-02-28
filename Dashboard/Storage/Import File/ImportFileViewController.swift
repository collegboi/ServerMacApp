//
//  ImportFileViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 08/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class ImportFileViewController: NSViewController, NSWindowDelegate {

    @IBOutlet weak var dBNameTextField: NSTextField!
    @IBOutlet weak var filePathLabel: NSTextField!
    
    @IBOutlet weak var databaseOutLineView: NSOutlineView!
    
    fileprivate var importTableDataSource: ImportTableDataSource!
    fileprivate var importTableDelegate: ImportTableDelegate!
    
    var  data:[[String:String]] = []
    var  columnTitles:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.delegate = self
        
        importTableDataSource = ImportTableDataSource(outlineView: databaseOutLineView)
        importTableDelegate = ImportTableDelegate(outlineView: databaseOutLineView)
        
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
    }
    
    @IBAction func selectFile(_ sender: Any) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a .csv or .json file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["csv", "json"];
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url
            
            if (result != nil) {
                let path = result!.path
                filePathLabel.stringValue = path
                
                let pathExtention = NSURL(fileURLWithPath: path).pathExtension
                
                if pathExtention == "csv" {
                    self.computeCSVFile(path)
                }
                
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    func computeCSVFile(_ filePath: String) {
        self.convertCSV(filePath)
        
        if data.count > 0 {
            self.data.remove(at: 0)
            self.importTableDataSource.reload(records: self.data)
        }
        //self.databaseOutLineView.expandItem(nil, expandChildren: true)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        HTTPSConnection.httpPostRequest(params: self.data, endPoint: "/storage/all/"+self.dBNameTextField.stringValue, appKey: "") { (completed, result) in
            
            DispatchQueue.main.async {
                if completed {
                    print("done")
                } else {
                    print("error")
                }
            }
        }
        
    }
}

extension ImportFileViewController {
    
    func readDataFromFile(file:String)-> String! {
        do {
            let contents = try String(contentsOfFile: file)
            return contents
        } catch {
            print ("File Read Error")
            return nil
        }
    }
    
    func getStringFieldsForRow(_ row:String, delimiter:String)-> [String]{
        return row.components(separatedBy: delimiter)
    }
    
    func convertCSV(_ file:String){
        
        let contents = readDataFromFile(file: file)
        
        if contents == nil {
            return
        }
        
        let rows = cleanRows(contents!).components(separatedBy: "\n")
        if rows.count > 0 {
            data = []
            columnTitles = getStringFieldsForRow(rows.first!,delimiter:",")
            for row in rows {
                let fields = getStringFieldsForRow(row,delimiter: ",")
                if fields.count != columnTitles.count {continue}
                var dataRow = [String:String]()
                for (index,field) in fields.enumerated(){
                    let fieldName = columnTitles[index]
                    dataRow[fieldName] = field
                }
                data += [dataRow]
            }
        } else {
            print("No data in file")
        }
    }
    
    func cleanRows(_ file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
}
