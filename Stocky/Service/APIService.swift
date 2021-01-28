//
//  APIService.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/14.
//

import Foundation
import Combine

            

struct APIService {
    
    enum APIServiceError: Error {
        case encoding
        case badRequest
    }
    
    var API_KEY : String {
        return keys.randomElement() ?? ""
    }
    
    let keys = ["VWG848WN4TOAHX1P", "R4QEF20WS1UNXOP2", "3YVKJCWZ41BU608T"]
    
    func fetchSymbolsPublisher(key : String) -> AnyPublisher<SearchResults, Error> {
        
        guard let key = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Fail(error: APIServiceError.encoding).eraseToAnyPublisher()
        }
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(key)&apikey=\(API_KEY)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIServiceError.badRequest).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
}
