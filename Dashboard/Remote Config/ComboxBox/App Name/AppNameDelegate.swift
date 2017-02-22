//
//  AppNameDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

typealias SelectApplication = (_ row: Int, _ application: TBApplication ) -> Void

class AppNameDelegate: NSObject {
    
    var appNames = [TBApplication]()
    
    var selectApplication: SelectApplication?
    fileprivate var comboxBox: NSComboBox
    
    init(comboxBox: NSComboBox , selectionBlock: @escaping SelectApplication) {
        self.comboxBox = comboxBox
        super.init()
        self.selectApplication = selectionBlock
        self.comboxBox.delegate = self
    }
    
    func reload(_ appNames: [TBApplication]  ) {
        self.appNames = appNames
        self.comboxBox.reloadData()
    }
    
}

extension AppNameDelegate: NSComboBoxDelegate {
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        guard let comboBox = notification.object as? NSComboBox else {
            return
        }
        let selectedRow = comboBox.indexOfSelectedItem
        let item = self.appNames[selectedRow]
        selectApplication?( selectedRow, item)
    }
    
}

