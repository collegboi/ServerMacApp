//
//  AppConfigVersionDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 09/03/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//


import Foundation
import Cocoa

typealias SelectConfigVersion = (_ row: Int, _ application: RemoteConfig ) -> Void

class AppConfigVersionDelegate: NSObject {
    
    var appVersions = [RemoteConfig]()
    
    var selectConfigVersion: SelectConfigVersion?
    fileprivate var comboxBox: NSComboBox
    
    init(comboxBox: NSComboBox , selectionBlock: @escaping SelectConfigVersion) {
        self.comboxBox = comboxBox
        super.init()
        self.selectConfigVersion = selectionBlock
        self.comboxBox.delegate = self
    }
    
    func reload(_ appVersions: [RemoteConfig]  ) {
        self.appVersions = appVersions
        self.comboxBox.reloadData()
    }
    
}

extension AppConfigVersionDelegate: NSComboBoxDelegate {
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        guard let comboBox = notification.object as? NSComboBox else {
            return
        }
        let selectedRow = comboBox.indexOfSelectedItem
        if selectedRow >= 0 {
            let item = self.appVersions[selectedRow]
            selectConfigVersion?( selectedRow, item)
        }
    }
}
