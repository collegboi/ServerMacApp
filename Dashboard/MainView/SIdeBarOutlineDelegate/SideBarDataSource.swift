//
//  SideBarDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 20/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class Item {
    let volume: String
    init(item: String) {
        self.volume = item
    }
}

class Section {
    
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
    
    func serviceList(_ row: Int ) -> String {
        let serviceLists = ["Storage", "Analytics", "Languages", "Notifications", "Remote Config", "AB Testing",
                            "Backup","Crashes", "New Service"]
        
        return serviceLists[row]
    }
    
    func reload() {
        
        let servicePerms = UserDefaults.standard.string(forKey: "services") ?? ""
        
        let servicesPerms = servicePerms.components(separatedBy: ",")
        
        var services = [Item]()

        for (index, aService ) in servicesPerms.enumerated() {
            
            let serviceIndex: Int = Int(aService) ?? 0
            
            if serviceIndex == 1 {
                services.append(Item(item: serviceList(index)))
            }
        }

        
        //let emptyArr = [Any]()
        
        let server = [
            Item(item: "Status"),
            Item(item: "Settings"),
            Item(item: "Logs")
        ]
        
        let accounts = [
            Item(item: "Staff"),
            Item(item: "Users")
        ]
        
//        let langs = [
//            Section.Item(item: "English"),
//            Section.Item(item: "French"),
//            Section.Item(item: "Russian")]
        
        let tracker = [
            Item(item: "Sprint Board"),
            Item(item: "Issues"),
            Item(item: "Charts")]
        
        sections = [
            Section(name: "Server", volumes: server),
            Section(name: "Accounts", volumes: accounts),
            Section(name: "Services", volumes: services ),
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

