//
//  SearchResults.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/14.
//

import Foundation



struct SearchResults : Decodable {
    
    let items : [SearchResult]
    
    enum CodingKeys : String, CodingKey {
        case items = "bestMatches"
    }
}

struct SearchResult : Decodable {
    let symbol : String
    let name : String
    let type : String
    let currency : String
    
    enum CodingKeys : String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case currency = "8. currency"
    }
}
