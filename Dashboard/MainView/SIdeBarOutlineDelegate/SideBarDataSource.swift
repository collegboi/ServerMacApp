//
//  SideBarDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 20/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class Section {
    
    class Item {
        let volume: String
        init(item: String) {
            self.volume = item
        }
    }
    
    let name: String
    let items: [Item]
    
    init(name: String, volumes: [Item]) {
        self.name = name
        self.items = volumes
    }
}

class SideBarDataSource: NSObject {
    
    var sections = [Section]()
    fileprivate var outlineView: NSOutlineView
    
    init(outlineView: NSOutlineView) {
        self.outlineView = outlineView
        super.init()
        self.outlineView.dataSource = self
    }
    
    func reload() {
        
        //let emptyArr = [Any]()
        
        
        let services = [
            Section.Item(item: "Storage"),
            Section.Item(item: "Analytics"),
            Section.Item(item: "Notificaitons"),
            Section.Item(item: "Remote Config"),
            Section.Item(item: "Backup"),
            Section.Item(item: "Crashes/Bugs"),
            Section.Item(item: "New Service")]
        
        let server = [
            Section.Item(item: "Status"),
            Section.Item(item: "Logs")
        ]
        
        let accounts = [
            Section.Item(item: "Stats"),
            Section.Item(item: "Admin"),
            Section.Item(item: "Users")
        ]
        
        let langs = [
            Section.Item(item: "English"),
            Section.Item(item: "French"),
            Section.Item(item: "Russian")]
        
        let tracker = [
            Section.Item(item: "Sprint Board"),
            Section.Item(item: "Issues"),
            Section.Item(item: "Charts")]
        
        sections = [
            Section(name: "Server", volumes: server),
            Section(name: "Accounts", volumes: accounts),
            Section(name: "Services", volumes: services ),
            Section(name: "Languages", volumes: langs),
            Section(name: "Tracker", volumes: tracker)
        ]
        
        outlineView.reloadData()
    }
}

extension SideBarDataSource: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return sections.count
        } else if let section = item as? Section {
            return section.items.count
        } else {
            return 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let section = item as? Section {
            return section.items[index]
        } else {
            return sections[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return item is Section
    }
}

