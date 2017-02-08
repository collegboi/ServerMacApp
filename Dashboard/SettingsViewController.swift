//
//  SettingsViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 08/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {

    @IBOutlet weak var keyFilePathLabel: NSTextField!
    @IBOutlet weak var certFilePathLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getFileNames()
    }
    
    
    func getFileNames() {
        
        let dict = [
            "type":"Notifications" as AnyObject
        ]
        
        var allFiles = [Files]()
        
        allFiles.getFilteredInBackground(ofType: Files.self, query: dict) { ( completed, files) in
            
            DispatchQueue.main.async {
                if completed {
                    allFiles = files
                    
                    if files.count > 1 {
                        self.keyFilePathLabel.stringValue = files[0].filePath
                        self.certFilePathLabel.stringValue = files[1].filePath
                    }
                }
            }
        }
        
    }
    
    @IBAction func selectKeyFile(_ sender: Any) {
        
        let keyFilePath = selectFileDialog("pem")
        
        if keyFilePath != "" {
            self.keyFilePathLabel.stringValue = keyFilePath
            self.sendFile(keyFilePath, name: "key.pem")
        }
    }
    
    @IBAction func selectCertFile(_ sender: Any) {
        
        let certFilePath = selectFileDialog("pem")
        
        if certFilePath != "" {
            self.certFilePathLabel.stringValue = certFilePath
            self.sendFile(certFilePath, name: "cert.pem")
        }
    }

    
    func selectFileDialog(_ fileType: String ) -> String {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a "+fileType+" file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = [fileType];
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url
            
            if (result != nil) {
                let path = result!.path
                return path
            }
        } else {
            return ""
        }
        
        return ""
    }
    
    func sendFile(_ filePath: String, name: String ) {
        
        HTTPSConnection.httpPostFileRequest(path: filePath, endPoint: "/upload/Notifications/", name: name ) { ( sent, message) in
            
            DispatchQueue.main.async {
                print(message)
            }
        }
        
    }
}
