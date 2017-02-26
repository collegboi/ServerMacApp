//
//  ViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 20/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var config : Config?
    
    fileprivate struct Constants {
        static let headerCellID = "HeaderCell"
        static let volumeCellID = "VolumeCell"
    }
    
    fileprivate var dataSource: SideBarDataSource!
    fileprivate var delegate: SideBarDelegate!
    
    @IBOutlet var outlineView: NSOutlineView!
    
    @IBOutlet var containerView: NSView!

    var currentController: NSViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = SideBarDataSource(outlineView: outlineView)
        delegate = SideBarDelegate(outlineView: outlineView) { volume in
            self.showVolumeInfo(volume)
        }
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        
        print("logging out")
            
        UserDefaults.standard.set(false, forKey: "login")
        
            
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let mainWindowController = storyboard.instantiateController(withIdentifier: "LoginWindow") as! NSWindowController
        
        if let mainWindow = mainWindowController.window{
            
            self.view.window?.close()
            
            let application1 = NSApplication.shared()
            application1.runModal(for: mainWindow)
            
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        loadVolumes()
        selectFirstVolume()
    }
    
    
    func loadVolumes() {
        dataSource.reload()
        outlineView.expandItem(nil, expandChildren: true)
    }

    
    func selectFirstVolume() {
        guard let item = dataSource.sections.first?.items.first else {
            return
        }
        
        changeDetailViewBody(item.volume)
        outlineView.selectRowIndexes(IndexSet(integer: outlineView.row(forItem: item)), byExtendingSelection: true)
    }
    
    
    func changeDetailViewBody(_ viewIndentifer: String) {
        
        let trimmedViewIndentifier = viewIndentifer.replacingOccurrences(of: " ", with: "")
        //let trimmedStoryBoardName = trimmedViewIndentifier.replacingOccurrences(of: "/", with: ":")

        
        let viewStoryboard = NSStoryboard(name: trimmedViewIndentifier, bundle: nil)
        
        guard let controller = viewStoryboard.instantiateController(withIdentifier: viewIndentifer ) as? NSViewController else {
            return
        }
        
        self.setContentViewController(controller, containerView: self.containerView)
        
        fit(childView: (controller as AnyObject).view, parentView: self.containerView)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func showVolumeInfo(_ volume: Item) {
        
        self.changeDetailViewBody(volume.volume)
    }
    
    func fit(childView: NSView, parentView: NSView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }

    func setContentViewController(_ contentViewController: NSViewController, containerView: NSView, animated:Bool = false) {
        
        if animated == true {
            
            self.cleanUpChildControllerIfPossible()
            self.addChildViewController(contentViewController)
            contentViewController.view.alphaValue = 1
            contentViewController.view.frame = containerView.bounds
            containerView.addSubview(contentViewController.view)
            self.currentController = contentViewController
            //self.contentViewController.w
            
//            NSAnimationContext.runAnimationGroup({ (context) in
//                contentViewController.view.alphaValue = 0
//            
//            }, completionHandler: {
//                self.cleanUpChildControllerIfPossible()
//                contentViewController.view.frame = containerView.bounds
//                self.addChildViewController(contentViewController)
//                containerView.addSubview(contentViewController.view)
//                //contentViewController.didMoveToParentViewController(self)
//                self.currentController = contentViewController
//            })
            
        } else {
            cleanUpChildControllerIfPossible()
            
            contentViewController.view.frame = containerView.bounds
            addChildViewController(contentViewController)
            containerView.addSubview(contentViewController.view)
            //contentViewController.didMoveToParentViewController(self)
            self.currentController = contentViewController
        }
    }
    
    // MARK: - Private
    private func cleanUpChildControllerIfPossible() {
        if let childController = currentController {
            childController.removeFromParentViewController()

            childController.view.removeFromSuperview()
            childController.removeFromParentViewController()
        }
    }


}
