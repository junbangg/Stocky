//
//  APIService.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/14.
//
import Foundation
import Combine

//MARK: - API 요청 프로토콜

protocol APIRequestable {
    func fetchPreviewData(with key: String) -> AnyPublisher<SearchResults, Error>
    func fetchTimeSeriesData(with key: String) -> AnyPublisher<TimeSeries, Error>
}

//MARK: - 메인 클래스

final class APIService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

//MARK: - 프로토콜 채택

extension APIService: APIRequestable {
    // TODO: keyParseResult 메서드로 묶어서 분리
    // TODO: urlstring 다른 방법으로 관리
    func fetchPreviewData(with key: String) -> AnyPublisher<SearchResults, Error> {
        let keyParseResult = parse(query: key)
        var keywords = String()
        
        switch keyParseResult {
        case .success(let query):
            keywords = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let urlString = APIOperation.symbolSearch(keywords).urlString
        let parsedURL = parse(urlString: urlString)
        
        switch parsedURL {
        case .success(let url):
            return session.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: SearchResults.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    // TODO: keyParseResult 메서드로 묶어서 분리
    // TODO: urlstring 다른 방법으로 관리
    func fetchTimeSeriesData(with key: String) -> AnyPublisher<TimeSeries, Error> {
        let keyParseResult = parse(query: key)
        var symbol = String()
        
        switch keyParseResult {
        case .success(let query):
            symbol = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let urlString = APIOperation.timeSeriesMonthlyAdjusted(symbol).urlString
        let parsedURL = parse(urlString: urlString)
        
        switch parsedURL {
        case .success(let url):
            return session.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: TimeSeries.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

//MARK: - 중첩 타입

private extension APIService {
    private enum APIServiceError: Error {
        case encoding
        case badRequest
    }
    
    private enum APIOperation {
        private enum APIString {
            static let baseURL = "https://www.alphavantage.co/"
            static let path = "query?function="
            static let symbolSearchString = "SYMBOL_SEARCH&keywords="
            static let timeSeriesMonthlyAdjustedString = "TIME_SERIES_MONTHLY_ADJUSTED&symbol="
            
        }

        private enum APIKey {
            static let baseQuery = "&apikey="
            static let apiKeys = ["VWG848WN4TOAHX1P", "R4QEF20WS1UNXOP2", "3YVKJCWZ41BU608T", "Y9PIZ80TZ0XV3HVA"]
            static var randomKey: String {
                return apiKeys.randomElement() ?? ""
            }
            
            static var keyString: String {
                return baseQuery + randomKey
            }
        }
        
        case symbolSearch(String)
        case timeSeriesMonthlyAdjusted(String)
        
        var urlString: String {
            switch self {
            case .symbolSearch(let keywords):
                return APIString.baseURL + APIString.path + APIString.symbolSearchString + keywords + APIKey.keyString
            case .timeSeriesMonthlyAdjusted(let symbol):
                return APIString.baseURL + APIString.path + APIString.timeSeriesMonthlyAdjustedString + symbol + APIKey.keyString
            }
        }
    }
}

//MARK: - Helper 메서드
private extension APIService {
    private func parse(query: String) -> Result<String, Error> {
        if let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return .success(query)
        }else {
            return .failure(APIServiceError.encoding)
        }
    }
    
    private func parse(urlString: String) -> Result<URL, Error> {
        if let url = URL(string: urlString) {
            return .success(url)
        }else {
            return .failure(APIServiceError.badRequest)
        }
    }
}
