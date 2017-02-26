//
//  EditAppViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class EditAppViewController: NSViewController, NSWindowDelegate {

    @IBOutlet weak var appViewLabel: NSTextField!
    @IBOutlet weak var appIconImageView: NSImageView!
    
    @IBOutlet weak var notifcationCheck: NSButton!
    
    @IBOutlet weak var itunesID: NSTextField!
    @IBOutlet weak var appName: NSTextField!
    
    @IBOutlet weak var appDescTextVIew: NSTextView!
    
    @IBOutlet weak var comboBoxAppType: NSComboBox!
    
    @IBOutlet weak var appID: NSTextField!
    @IBOutlet weak var priceTextField: NSTextField!
    @IBOutlet weak var ageRatingTextField: NSTextField!
    @IBOutlet weak var genresTextField: NSTextField!
    
    @IBOutlet weak var appKey: NSTextField!
    @IBOutlet weak var databaseName: NSTextField!
    
    @IBOutlet weak var appVersionTableView: NSTableView!
    
    fileprivate var appVersionDelegate: VersionViewDelegate!
    fileprivate var appVersionDataSource: AppViewDataSource!
    
    var application: TBApplication?
    var itunesResult: Result?
    var notificationSet: Bool = false
    var notificationSetting: NotificationSetting?
    var iconURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notifcationCheck.isEnabled = false
        self.notifcationCheck.state = 0
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
        
    }
    
    
    @IBAction func iTunesConnectButton(_ sender: Any) {
        
        if self.itunesID.stringValue == "" {
            return
        }
        
        guard Int(itunesID.stringValue) != nil else { return }
        
        iTunesRequestManager.getSearchResults( itunesID.stringValue) {
            (results, error) in
            
            let itunesResults = results.map{ return Result(dictionary: $0) }
                
                .enumerated()
                .map( { index, element -> Result in
                    element.rank = index + 1
                    return element
                })
            
            DispatchQueue.main.sync {
                
                guard let result = itunesResults.first else {return}
                self.itunesResult = result
            
                self.appName.stringValue = result.trackName
                self.appID.stringValue = result.bundleID
                self.priceTextField.stringValue = result.price.asLocaleCurrency
                self.ageRatingTextField.stringValue = result.trackContentRating
                self.genresTextField.stringValue = result.primaryGenre
                self.appDescTextVIew.string = result.itemDescription
                self.iconURL = result.artworkURL
                if let artURL = URL(string: result.artworkURL) {
                    self.loadIcon(artURL)
                }
            }
        }
    }
    
    func loadIcon(_ artworkURL: URL ) {
        
        iTunesRequestManager.downloadImage(artworkURL, completionHandler: { (image, error) -> Void in
            DispatchQueue.main.async(execute: {
                self.appIconImageView.image = image
            })
        })
    }
    
    
    @IBAction func createNewVersionButton(_ sender: Any) {
        
        let storyboard = NSStoryboard(name: "Settings", bundle: nil)
        let appWindowController = storyboard.instantiateController(withIdentifier: "AppVersion") as! NSWindowController
        
        if let appWindow = appWindowController.window {
            
            let editAppVersionViewController = appWindow.contentViewController as! AppVersionViewController
            editAppVersionViewController.appplicationID = self.application?.objectID?.objectID
            editAppVersionViewController.itunesResult = itunesResult
            editAppVersionViewController.itunesID = self.itunesID.stringValue
            
            let application = NSApplication.shared()
            application.runModal(for: appWindow)
        }

    }
    
    func showAppVersionWindow(_ appVersion: TBAppVersion ) {
        
        let storyboard = NSStoryboard(name: "Settings", bundle: nil)
        let appWindowController = storyboard.instantiateController(withIdentifier: "AppVersion") as! NSWindowController
        
        if let appWindow = appWindowController.window {
            
            let editAppVersionViewController = appWindow.contentViewController as! AppVersionViewController
            editAppVersionViewController.appplicationID = self.application?.objectID?.objectID
            editAppVersionViewController.appVersion = appVersion
            editAppVersionViewController.itunesID = self.itunesID.stringValue
            editAppVersionViewController.itunesResult = itunesResult
            
            let application = NSApplication.shared()
            application.runModal(for: appWindow)
        }
    }
    
    override func viewDidAppear() {
        
        self.view.window?.delegate = self
        
        appVersionDelegate = VersionViewDelegate(tableView: appVersionTableView ) { version in
            self.showAppVersionWindow(version)
        }
        appVersionDataSource = AppViewDataSource(tableView: appVersionTableView)
        
        if application == nil {
            self.appViewLabel.stringValue = "New Application"
            self.appKey.stringValue = UniqueSting.myNewUUID()
        } else {
            
            if notificationSet {
                self.notifcationCheck.state = self.application!.notificationSet
            }
            
            self.getVersionsData(self.application!.objectID!.objectID)
            self.appViewLabel.stringValue = "Edit Application"
            self.itunesID.stringValue = self.application!.itunesAppID
            
            self.appName.stringValue = self.application!.name
            self.appDescTextVIew.string = self.application!.appDescription
            self.priceTextField.stringValue = self.application!.appPrice
            self.ageRatingTextField.stringValue = self.application!.appRating
            self.genresTextField.stringValue = self.application!.appPrimaryGenre
            
            self.databaseName.stringValue = self.application!.databaseName
            self.appID.stringValue = self.application!.apID
            self.appKey.stringValue = self.application!.appKey
            self.comboBoxAppType.stringValue = self.application!.appType.rawValue
            
            self.iconURL = self.application?.itunesAppIconURL
            
            if let artURL = URL(string: (self.application?.itunesAppIconURL)! ) {
                self.loadIcon(artURL)
            }
            
        }
    }
    
    func getVersionsData(_ appID : String ) {
        
        var allVersions = [TBAppVersion]()
        
        allVersions.getFilteredInBackground(ofType: TBAppVersion.self, query: ["applicationID":appID as AnyObject]) { (retrieved, versions ) in
            
            DispatchQueue.main.async {
                
                if retrieved {
                    allVersions = versions
                    self.appVersionDelegate.reload(versions)
                    self.appVersionDataSource.reload(count: versions.count)
                }
            }
            
        }
        
    }
    
    @IBAction func appSendButton(_ sender: Any) {
        
        if application == nil {
            
            application = TBApplication(name: self.appName.stringValue,
                                        databaseName: self.databaseName.stringValue,
                                        apID: self.appID.stringValue,
                                        appKey: self.appKey.stringValue,
                                        appType: self.comboBoxAppType.stringValue,
                                        notificationSet: self.notifcationCheck.state,
                                        itunesAppID: self.itunesID.stringValue,
                                        itunesAppIconURL: self.iconURL,
                                        appPrice: self.priceTextField.stringValue,
                                        appRating: self.ageRatingTextField.stringValue,
                                        appDescription: self.appDescTextVIew.string ?? "",
                                        appPrimaryGenre: self.genresTextField.stringValue)
        } else {
            
            self.application?.name = self.appName.stringValue
            self.application?.databaseName = self.databaseName.stringValue
            self.application?.apID = self.appID.stringValue
            self.application?.appKey = self.appKey.stringValue
            self.application?.setApptype( self.comboBoxAppType.stringValue )
            self.application?.notificationSet = self.notifcationCheck.state
            self.application?.itunesAppID = self.itunesID.stringValue
            
            self.application?.appDescription = self.appDescTextVIew.string
            self.application?.appPrice = self.priceTextField.stringValue
            self.application?.appRating = self.ageRatingTextField.stringValue
            self.application?.appPrimaryGenre = self.genresTextField.stringValue
            self.application?.itunesAppIconURL = self.iconURL
            
            
        }
        
        if self.notificationSet {
            self.application?.setNotification(path: self.notificationSetting!.path, keyID: self.notificationSetting!.keyID, teamID: self.notificationSetting!.teamID )
        }
        
        application?.sendInBackground((self.application?.objectID?.objectID)!, postCompleted: { (sent, data) in
            
            DispatchQueue.main.async {
                if sent {
                    print("Sent")
                    self.view.window?.close()
                    let application = NSApplication.shared()
                    application.stopModal()
                }
            }
            
        })
        
    }
    
    @IBAction func appCancelButton(_ sender: Any) {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    
}
