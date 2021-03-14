//
//  DataChartView.swift
//  Stocky
//
//  Created by Jun Bang on 2021/03/12.
//

import Foundation
import UIKit
import TinyConstraints
import Charts

final class DataChartView : UIViewController, ChartViewDelegate {
    
    
    lazy var lineChartView : LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .themeGreenShade
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 13)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .outsideChart
        yAxis.axisLineColor = .white
        
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 13)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.axisLineColor = .white
        
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lineChartView)
        lineChartView.topToSuperview()
//        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        setData()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "Subscribers")
        
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
    }
    
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 10.0),
        ChartDataEntry(x: 1.0, y: 5.0),
        ChartDataEntry(x: 2.0, y: 7.0),
        ChartDataEntry(x: 3.0, y: 5.0),
        ChartDataEntry(x: 4.0, y: 19.0),
        ChartDataEntry(x: 5.0, y: 10.0),
        ChartDataEntry(x: 6.0, y: 17.0),
        ChartDataEntry(x: 7.0, y: 12.0),
        ChartDataEntry(x: 8.0, y: 2.0),
        ChartDataEntry(x: 9.0, y: 17.0),
        ChartDataEntry(x: 10.0, y: 12.0),
        ChartDataEntry(x: 11.0, y: 32.0),
        ChartDataEntry(x: 12.0, y: 6.0),
        ChartDataEntry(x: 13.0, y: 42.0),
        ChartDataEntry(x: 14.0, y: 34.0),
        ChartDataEntry(x: 15.0, y: 72.0),
        ChartDataEntry(x: 16.0, y: 43.0),
        ChartDataEntry(x: 17.0, y: 12.0),
        ChartDataEntry(x: 18.0, y: 22.0),
        ChartDataEntry(x: 19.0, y: 33.0),
        ChartDataEntry(x: 20.0, y: 55.0),
        ChartDataEntry(x: 21.0, y: 17.0),
        ChartDataEntry(x: 22.0, y: 18.0),
        ChartDataEntry(x: 23.0, y: 14.0)
    ]
    
    
}
