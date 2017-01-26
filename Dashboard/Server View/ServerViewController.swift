//
//  ServerViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class ServerViewController: NSViewController {
    
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var userView: UserView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userView.setBackgroundColor(NSColor.white)
        self.graphView.setBackgroundColor(NSColor.white)
        
        let mountedVolumes = VolumeInfo.mountedVolumes()
        
        let item = mountedVolumes[0]
        
        graphView.fileDistribution = item.fileDistribution

    }
    
}
