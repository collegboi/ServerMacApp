//
//  StaffStatsView.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa
import Charts

struct VisitorCount {
    var month: Int = Int(0)
    var count: Int = Int(0)
    
    init( month: Int, count: Int ) {
        self.month = month
        self.count = count
    }
}


class StaffStatsView: NSView {
    
    var months: [String]!
    
    var barChatView: BarChartView?
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func setBarChart(dataPoints: [String], values: [Double], label: String) {
        
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
    
    
    func updateChartWithData() {
        var dataEntries: [BarChartDataEntry] = []
        
        let visitorCounts = getVisitorCountsFromDatabase()
        
        for i in 0..<visitorCounts.count {
            let dataEntry = BarChartDataEntry(x: Double(visitorCounts[i].month), y: Double(visitorCounts[i].count))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Visitor count")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChatView?.data = chartData
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        barChatView?.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        
    }
    
    func getVisitorCountsFromDatabase() -> [VisitorCount] {
        
        var allVisitors = [VisitorCount]()
        
        let vistor1 = VisitorCount(month: 1, count: 5)
        let vistor2 = VisitorCount(month: 2, count: 10)
        let vistor3 = VisitorCount(month: 4, count: 20)
        let vistor4 = VisitorCount(month: 6, count: 4)
        let vistor5 = VisitorCount(month: 10, count: 2)
        
        allVisitors.append(vistor1)
        allVisitors.append(vistor2)
        allVisitors.append(vistor3)
        allVisitors.append(vistor4)
        allVisitors.append(vistor5)
        
        return allVisitors
    }

}
