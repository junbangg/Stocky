//
//  APIService.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/14.
//
import Foundation
import Combine

//MARK: API 요청 프로토콜
protocol APIRequestable {
    func fetchPreviewData(with key: String) -> AnyPublisher<SearchResults, Error>
    func fetchTimeSeriesData(with key: String) -> AnyPublisher<TimeSeries, Error>
    
}

//MARK: 메인 클래스
class APIService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

//MARK: 프로토콜 채택
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
        
        let urlString = APIServiceOperation.symbolSearch(keywords).urlString
        let urlParseResult = parse(urlString: urlString)
        
        switch urlParseResult {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url)
                .map({$0.data})
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
        
        let urlString = APIServiceOperation.timeSeriesMonthlyAdjusted(symbol).urlString
        let urlResult = parse(urlString: urlString)
        
        switch urlResult {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url)
                .map({$0.data})
                .decode(type: TimeSeries.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

//MARK: 중첩 타입
private extension APIService {
    private enum APIServiceError: Error {
        case encoding
        case badRequest
    }
    
    private enum APIServiceOperation {
        private enum APIServiceURL {
            static let baseString = "https://www.alphavantage.co/query?function="
            static let symbolSearchString = "SYMBOL_SEARCH&keywords="
            static let timeSeriesMonthlyAdjustedString = "TIME_SERIES_MONTHLY_ADJUSTED&symbol="
            static let apiKeyString = "&apikey="
            static let apiKeys = ["VWG848WN4TOAHX1P", "R4QEF20WS1UNXOP2", "3YVKJCWZ41BU608T", "Y9PIZ80TZ0XV3HVA"]
            static var API_KEY: String {
                return apiKeys.randomElement() ?? ""
            }
        }
        
        case symbolSearch(String)
        case timeSeriesMonthlyAdjusted(String)
        
        var urlString: String {
            switch self {
            case .symbolSearch(let keywords):
                return APIServiceURL.baseString + APIServiceURL.symbolSearchString + keywords + APIServiceURL.apiKeyString + APIServiceURL.API_KEY
            case .timeSeriesMonthlyAdjusted(let symbol):
                return APIServiceURL.baseString + APIServiceURL.timeSeriesMonthlyAdjustedString + symbol + APIServiceURL.apiKeyString + APIServiceURL.API_KEY
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
