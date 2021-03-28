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
import Combine

class DataChartViewController : UIViewController, ChartViewDelegate {
    
    var timeSeries : TimeSeries?
    var selectedIndex : Int?
    
    
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
        
        chartView.animate(xAxisDuration: 2.5)
        
        return chartView
    }()
    
//    override func viewWillAppear(_ animated: Bool) {
//        setData()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lineChartView)
        lineChartView.topToSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
//        setData()
    }
    
    /// New Experimental Code
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if selectedIndex != nil {
            setData()
            lineChartView.notifyDataSetChanged()
            super.viewDidLoad()
        }
        
        
    }
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    //MARK: - TODOS:
    /*
        - figure out how to change the position of highlightIndicator according to the dateSlider index
        - maybe use .circleColors() to indicate the highest price as a different color circle than the rest
     */
    func setData() {
        let priceData = LineChartDataSet(entries: getData(), label: "수정종가")
        
        priceData.mode = .cubicBezier
//        priceData.drawCirclesEnabled = false
        priceData.circleRadius = 3
//        priceData.circleColors = .init([.systemBlue, .systemRed, .white])
        priceData.lineWidth = 3
        priceData.setColor(.white)
        priceData.fill = Fill(color: .white)
        priceData.fillAlpha = 0.8
        priceData.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: priceData)
        lineChartView.data = data
    }
    
    private func getData() -> [ChartDataEntry]{
        let monthData : [MonthData] = timeSeries?.getMonthData(dateReverseSort: false) ?? []
        var chartValues : [ChartDataEntry] = []
        var x = 0
        /// New experimental code
        guard let startIndex = selectedIndex else { return chartValues }
        let endIndex = monthData.count
        for index in startIndex...endIndex {
            let priceData = monthData[index]
            let yData = priceData.adjustedClose
            let data = priceData.date
            let chartData = ChartDataEntry(x: x.doubleValue, y: yData, data: data)
            chartValues.append(chartData)
            x += 1
        }
        ///Working original code
//        for data in monthData {
//            let yData = data.adjustedClose
//            let data = data.date
//            let chartData = ChartDataEntry(x: x.doubleValue, y: yData, data: data)
//            chartValues.append(chartData)
//            x += 1
//        }
        return chartValues
    }
    
    
    
}
