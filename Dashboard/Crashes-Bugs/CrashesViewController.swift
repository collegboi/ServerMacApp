//
//  CrashesViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 01/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class CrashesViewController: NSViewController {
    
    @IBOutlet weak var crashStatsView: CrashStatsView!
    
    @IBOutlet weak var crashTableView: NSTableView!

    
    fileprivate var crashViewDelegate: CrashViewDelegate!
    fileprivate var crashViewDataSource: CrashViewDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        crashViewDataSource = CrashViewDataSource(tableView: crashTableView)
        crashViewDelegate = CrashViewDelegate(tableView: crashTableView) { execeptions in
            self.viewExceptionView(exception: execeptions)
        }
        
        self.getAllExeceptions()
    }
    
    func getAllExeceptions() {
        
        var allExeceptions = [Exceptions]()
        allExeceptions.getAllInBackground(ofType:Exceptions.self) { (succeeded: Bool, data: [Exceptions]) -> () in
            
            DispatchQueue.main.async {
                if (succeeded) {
                    allExeceptions = data
                    print("scucess")
                    
                    self.crashViewDelegate.reload(allExeceptions)
                    self.crashViewDataSource.reload(count: allExeceptions.count)
                    
                } else {
                    print("error")
                }
            }
        }
    }
    
    func viewExceptionView(exception: Exceptions ) {
        
        let storyboard = NSStoryboard(name: "ViewCrash", bundle: nil)
        let viewExceptionWindowController = storyboard.instantiateController(withIdentifier: "ViewException") as! NSWindowController
        
        if let viewExceptionWindow = viewExceptionWindowController.window {
            
            let viewCrashViewController = viewExceptionWindow.contentViewController as! ViewCrashViewController
            viewCrashViewController.exception = exception
            //viewCrashViewController.delegate = self
            
            let application = NSApplication.shared()
            application.runModal(for: viewExceptionWindow)
        }
    }
}
