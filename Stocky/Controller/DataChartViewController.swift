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
/**
 UIViewController to present Chart
 */
final class DataChartViewController: UIViewController, ChartViewDelegate {
    var timeSeries: TimeSeries?
    var selectedIndex: Int?
    //MARK: - Linechart View
    /// Creates Linechartview
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .themeGreenShade
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 15)
        yAxis.setLabelCount(4, force: false)
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .outsideChart
        yAxis.axisLineColor = .white
        
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 13)
        chartView.xAxis.valueFormatter = DateAxisValueFormatter()
        chartView.xAxis.granularity = 1.0
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.axisLineColor = .white
        chartView.animate(xAxisDuration: 2.5)
        
        return chartView
    }()
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lineChartView)
        lineChartView.topToSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        setData()
    }
    /// New Experimental Code for dynamic chart
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    //MARK: - TODOS:
    /*
     - figure out how to change the position of highlightIndicator according to the dateSlider index
     - maybe use .circleColors() to indicate the highest price as a different color circle than the rest
     */
    //MARK: - Set data
    /// Sets charts data and style configurations
    func setData() {
        let priceData = LineChartDataSet(entries: fetchData(), label: "수정종가")
        priceData.mode = .cubicBezier
        priceData.circleRadius = 3
        priceData.lineWidth = 3
        priceData.setColor(.white)
        priceData.fill = Fill(color: .white)
        priceData.fillAlpha = 0.8
        priceData.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: priceData)
        lineChartView.data = data
    }
    //MARK: - get data
    /// Fetches data from timeSeries and configures to [ChartDataEntry]
    private func fetchData() -> [ChartDataEntry]{
        let monthData: [MonthData] = timeSeries?.getMonthData(isReversed: false) ?? []
        var chartValues: [ChartDataEntry] = []
        var x = 0
        /// New experimental code
        //        guard let startIndex = selectedIndex else { return chartValues }
        //        let endIndex = monthData.count
        //        for index in startIndex...endIndex {
        //            let priceData = monthData[index]
        //            let yData = priceData.adjustedClose
        //            let data = priceData.date
        //            let chartData = ChartDataEntry(x: x.doubleValue, y: yData, data: data)
        //            chartValues.append(chartData)
        //            x += 1
        //        }
        ///Working original code
        for data in monthData {
            let yData = data.adjustedClose
            let data = data.date
            //            let chartData = ChartDataEntry(x: data, y: yData)
            let chartData = ChartDataEntry(x: x.doubleValue, y: yData, data: data)
            chartValues.append(chartData)
            x += 1
        }
        
        return chartValues
    }
}
/// Class that is used for configuring Xaxis labels
//https://stackoverflow.com/questions/54915102/trying-to-enter-date-string-in-chartdataentry
class DateAxisValueFormatter: NSObject, IAxisValueFormatter {
    let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let secondsPerDay = 24.0 * 3600.0
        let date = Date(timeIntervalSince1970: value * secondsPerDay)
        
        return dateFormatter.string(from: date)
    }
}
