//
//  AppVersionDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

typealias SelectVersion = (_ row: Int, _ application: TBAppVersion ) -> Void

class AppVersionDelegate: NSObject {
    
    var appVersions = [TBAppVersion]()
    
    var selectVersion: SelectVersion?
    fileprivate var comboxBox: NSComboBox
    
    init(comboxBox: NSComboBox , selectionBlock: @escaping SelectVersion) {
        self.comboxBox = comboxBox
        super.init()
        self.selectVersion = selectionBlock
        self.comboxBox.delegate = self
    }
    
    func reload(_ appVersions: [TBAppVersion]  ) {
        self.appVersions = appVersions
        self.comboxBox.reloadData()
    }
    
}

extension AppVersionDelegate: NSComboBoxDelegate {
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        guard let comboBox = notification.object as? NSComboBox else {
            return
        }
        let selectedRow = comboBox.indexOfSelectedItem
        if selectedRow >= 0 {
            let item = self.appVersions[selectedRow]
            selectVersion?( selectedRow, item)
        }
    }
}
