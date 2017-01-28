//
//  CustomCellView.swift
//  Dashboard
//
//  Created by Timothy Barnard on 27/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class CustomCellView: NSTableCellView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        
    }
    
    @IBOutlet weak var colorView : NSView!
    
    func configureCell( ) {
        
        //let color = UIColor(red: rccolor.red/255.0, green: rccolor.green/255.0, blue: rccolor.blue/255.0, alpha: rccolor.alpha)
        //colorView.backgroundColor = color
        //colorLabel.text = rccolor.name
    }
    
}
