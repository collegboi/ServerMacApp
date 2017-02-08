//
//  AnalyticsView.swift
//  Dashboard
//
//  Created by Timothy Barnard on 08/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

import Cocoa
import  Charts

struct TBAnalyitcs: JSONSerializable {
    
    var timeStamp: String = ""
    var method: String = ""
    var className: String = ""
    var fileName: String = ""
    
    init(dict: String) {}
    init() {}
    init(dict: [String]) {}
    init(dict: [String : Any]) {
        self.timeStamp = dict.tryConvert(forKey: "timeStamp")
        self.method = dict.tryConvert(forKey: "method")
        self.className = dict.tryConvert(forKey: "className")
        self.fileName = dict.tryConvert(forKey: "fileNam")
    }
}

@IBDesignable class AnalyticsView: NSView {
    
    var allTBAnalyitcs = [TBAnalyitcs]()
    
    private var dateFormatter : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
    
    private var nowDate: String {
        return self.dateFormatter.string(from: NSDate() as Date)
    }
    
    var lineChartView: LineChartView?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if self.lineChartView == nil {
            self.getAllAnayltics()
            self.lineChartView = LineChartView(frame: dirtyRect)
            self.addSubview(self.lineChartView!)
        } else {
            self.lineChartView?.removeFromSuperview()
            self.lineChartView = LineChartView(frame: dirtyRect)
            self.addSubview(self.lineChartView!)
        }
    }
    
    func setChart() {
    
        // Do any additional setup after loading the view.
        let dollars1 = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        // 1 - creating an array of data entries
        var yValues : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< months.count {
            yValues.append(ChartDataEntry(x: Double(i + 1), y: dollars1[i]))
        }
        
        let data = LineChartData()
        let ds = LineChartDataSet(values: yValues, label: "Months")
        
        data.addDataSet(ds)
        self.lineChartView!.data = data
    }
    
    func getAllAnayltics() {
        
        allTBAnalyitcs.getAllInBackground(ofType: TBAnalyitcs.self) { ( completed, allAnalytics ) in
            
            DispatchQueue.main.async {
                if completed {
                    self.allTBAnalyitcs = allAnalytics
                    self.setChart()
                }
            }
            
        }
    }

}
