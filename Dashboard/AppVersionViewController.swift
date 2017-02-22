//
//  AppVersionViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class AppVersionViewController: NSViewController, NSWindowDelegate {

    
    @IBOutlet weak var appVersionLabel: NSTextField!
    @IBOutlet weak var appVersionNo: NSTextField!
    @IBOutlet weak var appVersionDate: NSDatePicker!
    @IBOutlet weak var releaseNotes: NSTextView!
    @IBOutlet weak var imageScrollView: NSScrollView!
    
    var appVersion: TBAppVersion?
    var appplicationID: String?
    var itunesResult: Result?
    var itunesID: String?
    
    var containerView: NSView!
    
    var imageViewHeight: CGFloat?
    var imageViewWidth: CGFloat?
    
    var imageURLs = [String]()
    
    var allConstraints = [NSLayoutConstraint]()
    var views = [ String: NSView ]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageViewHeight = self.imageScrollView.frame.height
        self.imageViewWidth = self.imageScrollView.frame.height / 1.5
        
        containerView = NSView()
        containerView.frame = NSRect(x: 0, y: 0, width: 0, height: self.imageScrollView.frame.height)
        containerView.setBackgroundColor(NSColor.white)
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
    }
    
    @IBAction func getNewVersion(_ sender: Any) {
        
        if itunesID == nil {
            return
        }
        
        guard Int(itunesID!) != nil else { return }
        
        iTunesRequestManager.getSearchResults( itunesID! ) {
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
                self.imageURLs = result.screenShotURLs
                
                self.appVersionNo.stringValue = result.version
                self.releaseNotes.string = result.releaseNotes
                self.imageURLs = result.screenShotURLs
                self.appVersionDate.dateValue = result.releaseDate
                
                self.getScreenShots()
            }
        }
    }
    
    
    
    override func viewDidAppear() {
        
        self.view.window?.delegate = self
        
        if appVersion != nil {
            
            self.appVersionLabel.stringValue = "Edit Version"
            self.appVersionNo.stringValue = appVersion!.version
            self.releaseNotes.string = appVersion!.notes
            self.imageURLs = appVersion!.imageURLs
            
            self.getScreenShots()
            
            let formatter = DateFormatter()
            let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.locale = enUSPosixLocale as Locale!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            guard let releaseDate = formatter.date(from: self.appVersion!.date) else {
                return
            }
            self.appVersionDate.dateValue = releaseDate
            
            
            
        } else {
            
            self.appVersionLabel.stringValue = "New Version"
        }
    }
    
    func getScreenShots() {
            
        var scrollViewContextSize: CGFloat = 0
        var xPosition: CGFloat  = 0
        
        for (index,  screenShotURLString ) in self.imageURLs.enumerated() {
            
            if let screenShotURL = URL(string: screenShotURLString) {
                
                iTunesRequestManager.downloadImage(screenShotURL, completionHandler: { (image, error) -> Void in
                    DispatchQueue.main.async(execute: {
                        guard let image = image , error == nil else {
                            return;
                        }
                        
                        let xPoint = index * Int(self.imageViewWidth!)
                        
                        let imageView = NSImageView(frame: NSRect(x: CGFloat(xPoint) , y: 0, width: self.imageViewWidth! , height: self.imageViewHeight!))
                        imageView.image = image
                        
                        imageView.frame.origin.x = xPosition
                        
                        self.containerView.addSubview(imageView)
                        
                        xPosition += self.imageViewWidth!
                        scrollViewContextSize += self.imageViewWidth!
                        
                        //self.addConstraint(contraintStr: NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute., relatedBy: NSLayoutRelation.equal, toItem: imageScrollView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 8.0))

                        //let constraintImageView1 = NSLayoutConstraint(item: self.imageScrollView, attribute: .top, relatedBy: .equal , toItem: imageView , attribute: .top, multiplier: 1.0, constant: 1.0)
                        //let constraintImageView2 = NSLayoutConstraint(item: self.imageScrollView, attribute: .bottom, relatedBy: .equal , toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 8.0)
                        //self.view.addConstraint(constraintImageView1)
                        //self.view.addConstraint(constraintImageView2)
                        
                        self.containerView.frame = NSRect(x: 0, y: 0, width: scrollViewContextSize, height: self.imageScrollView.frame.height )
                    })
                    
                })
            }
        }
        self.imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.imageScrollView.documentView = containerView
    
    }
    
    func addConstraint( contraintStr: String, options: NSLayoutFormatOptions = [], metrics: [String:NSNumber] = [:] ) {
        
        let nsLayoutConstraint = NSLayoutConstraint.constraints(withVisualFormat: contraintStr, options: options, metrics: metrics, views: self.views)
        
        self.allConstraints += nsLayoutConstraint
    }

    
    @IBAction func cancelButton(_ sender: Any) {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let releaseDate = formatter.string(from: self.appVersionDate.dateValue)
        
        if appVersion == nil {
            
            appVersion = TBAppVersion(applicationID: appplicationID!,
                                      version: self.appVersionNo.stringValue,
                                      date: releaseDate,
                                      notes: self.releaseNotes.string!,
                                      imageURLs: self.imageURLs)
        } else {
            
            self.appVersion?.applicationID = appplicationID
            self.appVersion?.version = self.appVersionNo.stringValue
            self.appVersion?.date = releaseDate
            self.appVersion?.notes = self.releaseNotes.string
            self.appVersion?.imageURLs = self.imageURLs
        }
        
        
        appVersion?.sendInBackground((self.appVersion?.objectID?.objectID)!, postCompleted: { (sent, data) in
            
            DispatchQueue.main.async {
                if sent {
                    print("Verison sent")
                    self.view.window?.close()
                    let application = NSApplication.shared()
                    application.stopModal()
                }
            }
        })
    }
}
