//
//  ABTestingViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 08/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa


class ABTestingViewController: NSViewController {
    
    
    @IBOutlet weak var abTestingComboBox: NSComboBox!
    
    @IBOutlet weak var comboBoxApp: NSComboBox!
    
    fileprivate var appNameDelegate: AppNameDelegate!
    fileprivate var appNameDataSource: AppNameDataSource!
    
    @IBOutlet weak var AAnalyticsView: AnalyticsView!
    
    var allABTesting = [ABTesting]()
    
    var appKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getAllApps()
        
        appNameDataSource = AppNameDataSource(comboxBox: comboBoxApp)
        appNameDelegate = AppNameDelegate(comboxBox: comboBoxApp, selectionBlock: { ( row, app) in
            self.appKey = app.appKey
            self.getAllABTesting()
            //self.applicationID = (app.objectID?.objectID)!
        })
        
        self.AAnalyticsView.setBackgroundColor(NSColor.white)
        self.abTestingComboBox.delegate = self
        
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
    
    func getAllABTesting() {
        
        allABTesting.getAllInBackground(ofType: ABTesting.self, appKey: self.appKey ) { (completed, testing ) in
            
            DispatchQueue.main.async {
                
                if completed {
                    self.allABTesting = testing
                    
                    for test in testing {
                        
                        self.abTestingComboBox.addItem(withObjectValue: test.name)
                    }
                    
                    print("recieved")
                } else  {
                    print("not recieved")
                }
            }
        }
    }
    
    @IBAction func newABTestingButton(_ sender: Any) {
        
        let storyboard = NSStoryboard(name: "ABTesting", bundle: nil)
        let abTestingWindowController = storyboard.instantiateController(withIdentifier: "EditABTesting") as! NSWindowController
        
        if let abTestingWindow = abTestingWindowController.window{
            
            let application = NSApplication.shared()
            application.runModal(for: abTestingWindow)
        }

        
    }
    
}

extension ABTestingViewController: NSComboBoxDelegate {
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        guard let comboBox = notification.object as? NSComboBox else {
            return
        }
        
        print("comboBox objectValueOfSelectedItem: \(comboBox.objectValueOfSelectedItem)")
        /* This printed the correct selected String value */
        
        print("comboBox indexOfSelectedItem: \(comboBox.indexOfSelectedItem)")
        
    }
}
