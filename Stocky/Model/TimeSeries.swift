//
//  TimeSeriesMonthlyAdjusted.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/27.
//

import Foundation

/**
Datatype for storing retreived data of a particular month
 
# Components
    - date : date of data
    - adjustedOpen : 시작가
    - adjustedClose : 종가
 */
struct MonthData {
    let date: Date
    let adjustedOpen: Double
    let adjustedClose: Double
}
/**
Datatype for storing retreived TimeSeries data
 
# Components
    - meta : meta data of struct Meta
    - timeSeries : Dictionary of TimeSeries data [key : Date String, value : TSData]
    - func getMonthData() : Formats the timeSeries data to usable version
    - func calculateAdjustedOpen() : Calculates AdjustedOpen price
 */
struct TimeSeries : Decodable {
    
    let meta : Meta
    let timeSeries : [String: TSData]
    enum CodingKeys: String, CodingKey {
        case meta = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
    }
    /**
     Function for formatting and converting TimeSeries data to an Array of MonthDatas
     
     # Logic
     After sorting the TimeSeries data(reversed or normal), data is formatted to fit the MonthData struct
     
     - Parameter dateReverseSort: Used to differentiate whether the timeSeries data should be sorted in a reversed order or not
     - Returns: An array of sorted MonthData structs
     */
    func getMonthData(dateReverseSort: Bool) -> [MonthData] {
        var monthDataArray : [MonthData] = []
        
        /// Sorts by key(data, ex: "1999-12-31")
        let sortedTimeSeries = dateReverseSort ? timeSeries.sorted(by: {$0.key > $1.key}) : timeSeries.sorted(by: {$0.key < $1.key})
        
        /// Handeling optionals
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
                  let adjustedOpen = calculateAdjustedOpen(tsdata: data),
                  let adjustedClose = data.adjustedClose.convertToDouble() else { return [] }
            let monthData = MonthData(date: date, adjustedOpen: adjustedOpen, adjustedClose: adjustedClose)
            
            monthDataArray.append(monthData)
        }
        
        return monthDataArray
    }
    
    /// Function to compute adjustedOpen price
    /// - Parameter tsdata: TSData type with price data
    /// - Returns: Adjusted open price
    private func calculateAdjustedOpen(tsdata : TSData) -> Double? {
        
        guard let open = tsdata.open.convertToDouble(),
              let adjustedClose = tsdata.adjustedClose.convertToDouble(),
              let close = tsdata.close.convertToDouble() else { return nil }
        
        return open * adjustedClose / close
    }
}
/**
Datatype that acts as a header for the data
 
# Components
    - symbol : NASDAQ symbol (AAPL)
 */
struct Meta : Decodable {
    let symbol : String
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}
/**
Datatype that stores price related data
 
# Components
    - open : open price
    - close : closed price
    - adjustedClose : adjusted close price
 */
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
