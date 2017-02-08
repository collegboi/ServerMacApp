//
//  ABTestingViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 08/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa


class ABTestingViewController: NSViewController {
    
    
    @IBOutlet weak var AAnalyticsView: AnalyticsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AAnalyticsView.setBackgroundColor(NSColor.white)
       
    }
}
