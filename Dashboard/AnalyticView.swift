//
//  AnalyticView.swift
//  Dashboard
//
//  Created by Timothy Barnard on 13/03/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa
import Charts


class AnalyticView: NSView {
    
    var months: [String]!
    
    var barChatView: BarChartView?
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func setBarChart() {
        
        let frameRect = NSRect(x: 10, y: 10, width: self.frame.width - 10, height: self.frame.height - 10 )
        
        if self.barChatView == nil {
            self.barChatView = BarChartView(frame: frameRect)
            self.addSubview(self.barChatView!)
        } else {
            self.barChatView?.removeFromSuperview()
            self.barChatView = BarChartView(frame: frameRect)
            self.addSubview(self.barChatView!)
        }
        
        barChatView?.chartDescription!.text = ""
    }
    
    //analyticViews: [TBAnalyitcs]
    func updateChartWithData( label:String, analyticObjects: AnalyticObjects ) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<analyticObjects.allAnalyticObj.count {
            let dataEntry = BarChartDataEntry(x: Double(analyticObjects.allAnalyticObj[i].month ), y: Double(analyticObjects.allAnalyticObj[i].count), data: "Messsage" as AnyObject?)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        let chartData = BarChartData(dataSet: chartDataSet)
        barChatView?.data = chartData
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        barChatView?.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        //Also, you probably want to add:
        
    }
    
}
