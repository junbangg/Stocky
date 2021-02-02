//
//  TimeSeriesMonthlyAdjusted.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/27.
//

import Foundation

//{
//    "Meta Data": {
//        "1. Information": "Monthly Adjusted Prices and Volumes",
//        "2. Symbol": "IBM",
//        "3. Last Refreshed": "2021-01-26",
//        "4. Time Zone": "US/Eastern"
//    },
//    "Monthly Adjusted Time Series": {
//        "2021-01-26": {
//            "1. open": "125.8500",
//            "2. high": "132.2400",
//            "3. low": "117.3600",
//            "4. close": "122.4900",
//            "5. adjusted close": "122.4900",
//            "6. volume": "144112874",
//            "7. dividend amount": "0.0000"
//        },


struct TimeSeries : Decodable {
    
    let meta : Meta
    let timeSeries : [String: TSData]
    enum CodingKeys: String, CodingKey {
        case meta = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
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
