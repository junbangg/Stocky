//
//  SearchResults.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/14.
//

import Foundation

/**
Model Datatype for storing an array of Search results
 
 # Components
    - items : Array of SearchResult structs
 */

struct SearchResults: Decodable {
    let items: [SearchResult]
    enum CodingKeys: String, CodingKey {
        case items = "bestMatches"
    }
}

/**
Struct to store search result data
 
 # Components
    - symbol  : NASDAQ code ( ex. AAPL)
    - name  : Name of company (ex. Apple)
    - type :
    - currency : type of currency (ex. USD, EURO)
 */

struct SearchResult: Decodable {
    let symbol: String
    let name: String
    let type: String
    let currency: String

    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case currency = "8. currency"
    }
}
