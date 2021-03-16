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

struct TimeSeries : Decodable {
    
    let meta : Meta
    let timeSeries : [String: TSData]
    enum CodingKeys: String, CodingKey {
        case meta = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
    }
    
    func getMonthData(dateReverseSort: Bool) -> [MonthData] {
        var monthDatas : [MonthData] = []
        
        
        let sortedTimeSeries = dateReverseSort ? timeSeries.sorted(by: {$0.key > $1.key}) : timeSeries.sorted(by: {$0.key < $1.key})
        
        
        ///Handeled optionals
        //        sortedTimeSeries.forEach { (dateString, data) in
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.dateFormat = "yyyy-MM-dd"
        //            let date = dateFormatter.date(from: dateString)! //have to handle optional
        //            let adjustedOpen = getAdjustedOpen(tsdata: data)
        //            let monthData = MonthData(date: date, adjustedOpen: adjustedOpen, adjustedClose: Double(data.adjustedClose)!)
        //
        //            monthDatas.append(monthData)
        //        }
        for (dateString, data) in sortedTimeSeries {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: dateString),
                  let adjustedOpen = getAdjustedOpen(tsdata: data),
                  let adjustedClose = data.adjustedClose.convertToDouble() else { return [] }
            let monthData = MonthData(date: date, adjustedOpen: adjustedOpen, adjustedClose: adjustedClose)
            
            monthDatas.append(monthData)
        }
        
        return monthDatas
    }
    
    private func getAdjustedOpen(tsdata : TSData) -> Double? {
        
        /// Handeled Optionals
        guard let open = tsdata.open.convertToDouble(),
              let adjustedClose = tsdata.adjustedClose.convertToDouble(),
              let close = tsdata.close.convertToDouble() else { return nil }
        
        return open * adjustedClose / close
    }
}

struct Meta : Decodable {
    let symbol : String
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}

struct TSData : Decodable {
    let open : String
    let close : String
    let adjustedClose : String
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
    }
}
