//
//  TimeSeriesMonthlyAdjusted.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/27.
//
import Foundation

struct MonthData {
    let date: Date
    let adjustedOpen: Double
    let adjustedClose: Double
}

struct TimeSeries: Decodable {
    let meta: Meta
    let timeSeries: [String: TimeSeriesData]
    
    enum CodingKeys: String, CodingKey {
        case meta = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
    }
    
    func getMonthData(isReversed: Bool) -> [MonthData] {
        var monthDataArray: [MonthData] = []
        let sortedTimeSeries = isReversed ? timeSeries.sorted(by: {$0.key > $1.key}) : timeSeries.sorted(by: {$0.key < $1.key})
        let dateFormatter = createDateFormatter()
        
        for (dateString, data) in sortedTimeSeries {
            guard let date = dateFormatter.date(from: dateString),
                  let adjustedOpen = calculateAdjustedOpen(with: data),
                  let adjustedClose = data.adjustedClose.convertToDouble() else {
                return []
            }
            let monthData = MonthData(date: date, adjustedOpen: adjustedOpen, adjustedClose: adjustedClose)
            
            monthDataArray.append(monthData)
        }
        return monthDataArray
    }
    
    private func createDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
    
    private func calculateAdjustedOpen(with timeSeriesData: TimeSeriesData) -> Double? {
        guard let open = timeSeriesData.open.convertToDouble(),
              let adjustedClose = timeSeriesData.adjustedClose.convertToDouble(),
              let close = timeSeriesData.close.convertToDouble() else {
            return nil
        }
        return open * adjustedClose / close
    }
}

struct Meta: Decodable {
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}

struct TimeSeriesData: Decodable {
    let open: String
    let close: String
    let adjustedClose: String
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
    }
}
