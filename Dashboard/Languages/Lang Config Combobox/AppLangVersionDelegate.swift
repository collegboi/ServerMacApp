//
//  AppLangVersionDelegate.swift
//  Dashboard
//
//  Created by Timothy Barnard on 12/03/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

typealias SelectLangVersion = (_ row: Int, _ application: LanguageVersion ) -> Void

class AppLangVersionDelegate: NSObject {
    
    var langVersions = [LanguageVersion]()
    
    var selectLangVersion: SelectLangVersion?
    fileprivate var comboxBox: NSComboBox
    
    init(comboxBox: NSComboBox , selectionBlock: @escaping SelectLangVersion) {
        self.comboxBox = comboxBox
        super.init()
        self.selectLangVersion = selectionBlock
        self.comboxBox.delegate = self
    }
    
    func reload(_ langVersions: [LanguageVersion]  ) {
        self.langVersions = langVersions
        self.comboxBox.reloadData()
    }
    
}

extension AppLangVersionDelegate: NSComboBoxDelegate {
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        guard let comboBox = notification.object as? NSComboBox else {
            return
        }
        let selectedRow = comboBox.indexOfSelectedItem
        if selectedRow >= 0 {
            let item = self.langVersions[selectedRow]
            selectLangVersion?( selectedRow, item)
        }
    }
}

