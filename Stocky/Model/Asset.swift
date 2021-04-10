//
//  Asset.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/02/03.
//

import Foundation

/**
Model datatype for storing the initial search(fetch) results
 
# Components
    - searchResult : SearchResult struct containing stock data
    - timeSeries : TimeSeries struct containing specific price data
 */

struct Asset {
    
    let searchResult : SearchResult
    let timeSeries : TimeSeries
}
