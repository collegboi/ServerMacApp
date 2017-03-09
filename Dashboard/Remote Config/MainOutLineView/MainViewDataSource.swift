//
//  SideBarDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 20/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

struct RCTableObject {
    
    var rcObject : RCObject!
    var parentRow: Int!
    var row: Int!
    
    init(rcObject: RCObject, parentRow: Int, row: Int) {
        self.rcObject = rcObject
        self.parentRow = parentRow
        self.row = row
    }
}

class MainViewDataSource: NSObject {
    
    var config : Config?
    var curParentRow: Int = 0
    
    fileprivate var outlineView: NSOutlineView
    
    init(outlineView: NSOutlineView) {
        self.outlineView = outlineView
        super.init()
        self.outlineView.dataSource = self
    }
    
    func reload( config: Config ) {
        //self.getRemoteConfigFiles()
        self.config = config
        self.outlineView.reloadData()
    }
}

extension MainViewDataSource: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if let contoller = item as? RCController {
            return contoller.objectsList.count
        }
        
        guard let contollerCount = self.config?.controllers.count else {
            return 0
        }
        
        return contollerCount
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        if let controller = item as? RCController {
            
            let object = RCTableObject(rcObject: controller.objectsList[index],
                                       parentRow: controller.parent, row: index)
            
            return object //contoller.objectsList[index]
        
        } else {
            
            self.config?.controllers[index].parent = index
            
            return self.config!.controllers[index]
        }
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        if let controller = item as? RCController  {
            return controller.objectsList.count > 0
        }
        
        return false
    }
}
