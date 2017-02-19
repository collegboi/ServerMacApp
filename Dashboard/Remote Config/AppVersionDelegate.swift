//
//  AppVersionDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 19/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

typealias SelectVersion = (_ row: Int, _ application: RemoteConfig ) -> Void

class AppVersionDelegate: NSObject {
    
    var appVersions = [RemoteConfig]()
    
    var selectVersion: SelectVersion?
    fileprivate var comboxBox: NSComboBox
    
    init(comboxBox: NSComboBox , selectionBlock: @escaping SelectVersion) {
        self.comboxBox = comboxBox
        super.init()
        self.selectVersion = selectionBlock
        self.comboxBox.delegate = self
    }
    
    func reload(_ appVersions: [RemoteConfig]  ) {
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
        let item = self.appVersions[selectedRow]
        selectVersion?( selectedRow, item)
    }
}
