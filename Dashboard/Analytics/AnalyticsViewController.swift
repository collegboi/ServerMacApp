//
//  AnalyticsViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 13/03/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class AnalyticObjects {
    var allAnalyticObj = [AnalyticObj]()
    var name: String = ""
    
    init( name: String ) {
        self.name = name
    }
}

class AnalyticObj {
    var month: Int = 0
    var count: Int = 0
    
    init( month: Int, count: Int ) {
        self.month = month
        self.count = count
    }
}


class AnalyticsViewController: NSViewController {

    @IBOutlet weak var scrollView: NSScrollView!
    var containerView: NSView!
    
    @IBOutlet weak var comboBoxVersion: NSComboBox!
    @IBOutlet weak var comboBoxApp: NSComboBox!
    
    fileprivate var appNameDelegate: AppNameDelegate!
    fileprivate var appNameDataSource: AppNameDataSource!
    
    fileprivate var appVersionDelegate: AppVersionDelegate!
    fileprivate var appVersionDataSource: AppNameDataSource!
    
    var appKey: String = ""
    var applicationID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView = NSView()
        containerView.frame = NSRect(x: 0, y: 0, width: self.scrollView.frame.width, height: 0)
        containerView.setBackgroundColor(NSColor.lightGray)
        
        self.getAllApps()
        
        appNameDataSource = AppNameDataSource(comboxBox: comboBoxApp)
        appNameDelegate = AppNameDelegate(comboxBox: comboBoxApp, selectionBlock: { ( row, app) in
            self.appKey = app.appKey
            self.applicationID = (app.objectID?.objectID)!
            self.comboBoxVersion.removeAllItems()
            //self.comboBoxVersion.reloadData()
            self.getAllAppsVersions((app.objectID?.objectID)!)
        })
        
        appVersionDataSource = AppNameDataSource(comboxBox: comboBoxVersion)
        appVersionDelegate = AppVersionDelegate(comboxBox: comboBoxVersion, selectionBlock: { ( row, version) in
            
            self.getAllAnayltics(version.version)
        })
    }
    
    func getAllAppsVersions(_ appID: String) {
        
        var allVersions = [TBAppVersion]()
        
        allVersions.getFilteredInBackground(ofType: TBAppVersion.self, query: ["applicationID":appID as AnyObject]) { (retrieved, versions ) in
            
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
    
    func getAllAnayltics(_ version: String ) {
        
        var allAnalytics = [TBAnalytics]()
        
        //let versionObject = ["Build version":version]
        //let queryObjects = ["tags": versionObject]
        
        allAnalytics.getAllInBackground(ofType: TBAnalytics.self, appKey: self.appKey) { ( retrieved, allTBAnalytics ) in
        //allAnalytics.getFilteredInBackground(ofType: TBAnalyitcs.self, query: queryObjects as [String : AnyObject], appKey: self.appKey) { ( retrieved, allTBAnalytics ) in
            DispatchQueue.main.async {
                if retrieved {
                    
                    allAnalytics = allTBAnalytics
                    self.separateAnalytics(allTBAnalytics)
                }
            }
        }
    }
    
    func separateAnalytics( _ allAnalytics: [TBAnalytics] ) {
        

        var allAnalyticObjects = [AnalyticObjects]()
        
        for analytic in allAnalytics {
            
            let analyticObjects = findValue( allAnalyticObjects, value: analytic.type)
            
            if analyticObjects != nil {
            
                let calendar = Calendar.current
                let month = calendar.component(.month, from: analytic.date! as Date)
                
                let sAnalyticObj = findValue(analyticObjects!, value: month)
                
                if sAnalyticObj != nil {
                    
                    sAnalyticObj!.count += 1
                    
                } else {
                    
                    let newAnalyticObj = AnalyticObj(month: month, count: 1)
                    
                    analyticObjects!.allAnalyticObj.append(newAnalyticObj)
                }
                
                
            } else {
                
                let newAnalyticObjects = AnalyticObjects(name: analytic.type)
                
                let calendar = Calendar.current
                let month = calendar.component(.month, from: analytic.date! as Date)
                
                let sAnalyticObj = findValue(newAnalyticObjects, value: month)
                
                if sAnalyticObj != nil {
                    
                    sAnalyticObj!.count += 1
                    
                } else {
                 
                    let newAnalyticObj = AnalyticObj(month: month, count: 1)
                    
                    newAnalyticObjects.allAnalyticObj.append(newAnalyticObj)
                }
                
                allAnalyticObjects.append(newAnalyticObjects)
            }
        }

        self.createViews( allAnalyticObjects )
    }
    
    func findValue(_ allAnalyticObjects: [AnalyticObjects], value: String) -> AnalyticObjects? {
        
        for analyticObjects in allAnalyticObjects {
            
            if analyticObjects.name == value {
                return analyticObjects
            }
        }
        return nil
    }
    
    
    func findValue(_ allAnalyticObjects: AnalyticObjects, value: Int) -> AnalyticObj? {
        
        for analyticObjects in allAnalyticObjects.allAnalyticObj {
            
            if analyticObjects.month == value {
                return analyticObjects
            }
        }
        return nil
    }
    
    func createViews( _ analyticViews: [AnalyticObjects] ) {
        
        var scrollViewContextSize: CGFloat = 0
        var yPosition: CGFloat  = 0
        let commentHeight: CGFloat = 210
        
        for (index, aView ) in analyticViews.enumerated() {
            
            let view = AnalyticView(frame: NSRect(x: 10, y: index * 100, width: Int(self.scrollView.frame.width - 20), height: 200))
            view.setBackgroundColor(NSColor.white)
            view.setBarChart()
            view.updateChartWithData(label: aView.name, analyticObjects : aView)
            
            view.frame.origin.y = yPosition
            
            containerView.addSubview(view)
            
            yPosition += commentHeight
            scrollViewContextSize += commentHeight
            
            self.containerView.frame = NSRect(x: 0, y: 0, width: self.scrollView.frame.width, height: scrollViewContextSize)
        }
        
        self.scrollView.documentView = containerView
        
    }

}


