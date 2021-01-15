//
//  APIService.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/14.
//

import Foundation
import Combine

            

struct APIService {
    var API_KEY : String {
        return keys.randomElement() ?? ""
    }
    
    let keys = ["VWG848WN4TOAHX1P", "R4QEF20WS1UNXOP2", "3YVKJCWZ41BU608T"]
    
    func fetchSymbolsPublisher(key : String) -> AnyPublisher<SearchResults, Error> {
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(key)&apikey=\(API_KEY)"
        
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
}
