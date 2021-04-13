//
//  APIService.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/14.
//

/// Networking
import Foundation
import Combine

/**
 Struct used for networking with API
 
 # Components
 - enum APIServiceError  : Error cases
 - var API_KEY : chooses a random api key provided in apiKeys
 - let apiKeys : array of valid apikeys (for consistency)
 - public func fetchSymbolsPublisher(key) : Used to fetch data to present in SearchTableViewController when user searches for stock
 - public func fetchTimeSeries(key) : Used to fetch more detailed data when user selects a search result in SearchTableViewController
 - private func parseQuery() : Used to format query string into usable in URL String
 - private func pareseURL(): Used to format url string to URL type
 */
struct APIService {
    
    /// Error enum type
    enum APIServiceError: Error {
        case encoding
        case badRequest
    }
    /// Variable that will choose a random key from apiKeys
    var API_KEY : String {
        return apiKeys.randomElement() ?? ""
    }
    /// Array of valid API keys
    let apiKeys = ["VWG848WN4TOAHX1P", "R4QEF20WS1UNXOP2", "3YVKJCWZ41BU608T", "Y9PIZ80TZ0XV3HVA"]
    
    /// Function used to network with API to fetch data to present in SearchTableViewContoller when user inputs search query
    /// - Parameter key : User search query
    /// - Returns: AnyPublisher<SearchResults, Error>
    func fetchPreviewData(key : String) -> AnyPublisher<SearchResults, Error> {
        
        /// Parses key into "keywords" that will be used in networking URL string
        let keyParseResult = parseQuery(text: key)
        var keywords = String()
        switch keyParseResult {
        case .success(let query):
            keywords = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        /// Preparation for networking with API.
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        /// Parses URL String
        let urlParseResult = parseURL(urlString: urlString)
        switch urlParseResult {
        case .success(let url):
            /// Perform Networking
            return URLSession.shared.dataTaskPublisher(for: url)
                .map({$0.data})
                .decode(type: SearchResults.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    /// Function used to network with API to fetch time series data (when user taps on a search result)
    /// - Parameter key: NADAQ Code(symbol) of stock to search
    /// - Returns: AnyPublisher<TimeSeries, Error>
    func fetchTimeSeriesData(key: String) -> AnyPublisher<TimeSeries, Error> {
        /// Parses Search query into "symbol" that will be used in networking URL string
        let keyParseResult = parseQuery(text: key)
        var symbol = String()
        switch keyParseResult {
        case .success(let query):
            symbol = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(API_KEY)"
        /// Parses URL
        let urlResult = parseURL(urlString: urlString)
        switch urlResult {
        case .success(let url):
            /// Performs Networking
            return URLSession.shared.dataTaskPublisher(for: url)
                .map({$0.data})
                .decode(type: TimeSeries.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    
    /// Function to parse text into string usable in URL String
    /// - Parameter text: text to parse
    /// - Returns: Result<String, Error>
    private func parseQuery(text: String) -> Result<String, Error> {
        /// text is encoded
        if let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return .success(query)
        }else {
            return .failure(APIServiceError.encoding)
        }
    }
    
    /// Function to parse urlstring into URL Format
    /// - Parameter urlString: original urlString
    /// - Returns: Result<URL, Error>
    private func parseURL(urlString: String) -> Result<URL, Error> {
        /// raw url string is converted to URL format
        if let url = URL(string: urlString) {
            return .success(url)
        }else {
            return .failure(APIServiceError.badRequest)
        }
    }
}
