//
//  NSView+Ext.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

extension NSView {
    func setBackgroundColor(_ color: NSColor) {
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
}

extension NSTextView {
    func appendAndScroll(string: String) {
        self.textStorage?.append(NSAttributedString(string: string))
        self.scrollToEndOfDocument(nil)
    }
}
