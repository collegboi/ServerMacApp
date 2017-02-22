//
//  AppNameDataSource.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

class AppNameDataSource: NSObject {
    
    var count: Int = 0
    
    fileprivate var comboxBox: NSComboBox
    
    init(comboxBox: NSComboBox) {
        self.comboxBox = comboxBox
        super.init()
        self.comboxBox.dataSource = self
    }
    
    func reload(_ count: Int  ) {
        self.count = count
        self.comboxBox.reloadData()
    }
    
}

extension AppNameDataSource: NSComboBoxDataSource {
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return "Timothy"
    }
}

