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

struct TBAnalyticTags: JSONSerializable {
 
    var osVersion: String = ""
    var deviceMake: String = ""
    var buildVersion: String = ""
    var buildName: String = ""
    var deviceModelName: String = ""
    
    init(dict: String) {}
    init() {}
    init(dict: [String]) {}
    init(dict: [String : Any]) {
        self.osVersion = dict.tryConvert(forKey: "OS version")
        self.deviceMake = dict.tryConvert(forKey: "Device make")
        self.buildVersion = dict.tryConvert(forKey: "Build version")
        self.buildName = dict.tryConvert(forKey: "Build name")
        self.deviceModelName = dict.tryConvert(forKey: "Device model name")
    }
}

struct TBAnalytics: JSONSerializable {
    
    var date: NSDate?
    var timeStamp: String = ""
    var method: String = ""
    var className: String = ""
    var fileName: String = ""
    var type: String = ""
    var tags: TBAnalyticTags?
    
    init(dict: String) {}
    init() {}
    init(dict: [String]) {}
    init(dict: [String : Any]) {
        self.timeStamp = dict.tryConvert(forKey: "timeStamp")
        self.method = dict.tryConvert(forKey: "method")
        self.className = dict.tryConvert(forKey: "className")
        self.fileName = dict.tryConvert(forKey: "fileName")
        self.type = dict.tryConvert(forKey: "type")
        self.tags = TBAnalyticTags(dict: dict.tryConvertObj(forKey: "tags"))
        self.date = self.dateFormatter.date(from: dict.tryConvert(forKey: "timeStamp")) as NSDate?
    }
    
    private var dateFormatter : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
}

@IBDesignable class AnalyticsView: NSView {
    
    var allTBAnalyitcs = [TBAnalytics]()
    
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
        let dollars2 = [10.0, 1.0, 2.0, 10.0, 20.0, 4.0, 18.0, 18.0, 6.0, 4.0, 5.0, 4.0]
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        // 1 - creating an array of data entries
        var yValues : [ChartDataEntry] = [ChartDataEntry]()
        var yValues2 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< months.count {
            yValues.append(ChartDataEntry(x: Double(i + 1), y: dollars1[i]))
        }
        
        for i in 0 ..< months.count {
            yValues2.append(ChartDataEntry(x: Double(i + 1), y: dollars2[i]))
        }
        
        let data = LineChartData()
        let ds = LineChartDataSet(values: yValues, label: "Months")
        ds.setColor(NSColor.red)
        
        let ds2 = LineChartDataSet(values: yValues2, label: "Months")
        ds2.setColor(NSColor.blue)
        
        data.addDataSet(ds)
        data.addDataSet(ds2)
        self.lineChartView!.data = data
    }
    
    func getAllAnayltics() {
        
        allTBAnalyitcs.getAllInBackground(ofType: TBAnalytics.self) { ( completed, allAnalytics ) in
            
            DispatchQueue.main.async {
                if completed {
                    self.allTBAnalyitcs = allAnalytics
                    self.setChart()
                }
            }
            
        }
    }

}
