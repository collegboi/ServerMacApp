//
//  SystemsView.swift
//  Dashboard
//
//  Created by Timothy Barnard on 11/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa
import Charts

class SystemsView: NSView {

    var months: [String]!
    
    var pieChartView: PieChartView?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func setPieChart(dataPoints: [String], values: [Double], label: String) {
        
        let frameRect = NSRect(x: 10, y: 10, width: self.frame.width - 10, height: self.frame.height - 10 )
        
        if self.pieChartView == nil {
            self.pieChartView = PieChartView(frame: frameRect)
            self.addSubview(self.pieChartView!)
        } else {
            self.pieChartView?.removeFromSuperview()
            self.pieChartView = PieChartView(frame: frameRect)
            self.addSubview(self.pieChartView!)
        }

        
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: label)
        let pieChartData = PieChartData(dataSets: [pieChartDataSet])
        pieChartView?.data = pieChartData
        pieChartView?.chartDescription!.text = ""
        
        var colors: [NSColor] = []
        
        let color1 = NSColor(colorLiteralRed: 51/255, green: 102/255, blue: 153/255, alpha: 1)
        let color2 = NSColor(colorLiteralRed: 153/255, green: 0/255, blue: 51/255, alpha: 1)
        
        colors.append(color1)
        colors.append(color2)
        
        pieChartDataSet.colors = colors
    }
}
